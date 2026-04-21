import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.1"

const SUPABASE_URL = Deno.env.get('SUPABASE_URL') as string
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') as string
const API_FOOTBALL_KEY = Deno.env.get('API_FOOTBALL_KEY') as string

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

const API_HOST = "v3.football.api-sports.io"
const HEADERS = {
  "x-rapidapi-host": API_HOST,
  "x-rapidapi-key": API_FOOTBALL_KEY
}

serve(async (req) => {
  try {
    // 1. Fetch live matches (status: live)
    const fixturesResp = await fetch(`https://${API_HOST}/fixtures?live=all`, { headers: HEADERS })
    const fixturesData = await fixturesResp.json()

    if (!fixturesData || !fixturesData.response) {
      return new Response(JSON.stringify({ error: "Failed to fetch fixtures" }), { headers: { "Content-Type": "application/json" } })
    }

    const matchesToUpsert = []
    const teamsToUpsert = []
    const leaguesToUpsert = []

    for (const item of fixturesData.response) {
      // Upsert League
      leaguesToUpsert.push({
        id: item.league.id,
        label: item.league.name,
        season: item.league.season.toString()
      })

      // Upsert Teams
      teamsToUpsert.push({ id: item.teams.home.id, name: item.teams.home.name, flag_url: item.teams.home.logo })
      teamsToUpsert.push({ id: item.teams.away.id, name: item.teams.away.name, flag_url: item.teams.away.logo })

      // Match Data
      matchesToUpsert.push({
        id: item.fixture.id,
        league_id: item.league.id,
        status: item.fixture.status.short === 'FT' ? 'FT' : 'LIVE',
        minute: item.fixture.status.elapsed,
        home_team_id: item.teams.home.id,
        away_team_id: item.teams.away.id,
        home_score: item.goals.home || 0,
        away_score: item.goals.away || 0,
        venue_name: item.fixture.venue.name,
        kickoff_time: new Date(item.fixture.timestamp * 1000).toISOString()
      })
    }

    // Process DB Upserts
    if (leaguesToUpsert.length > 0) {
      const uniqueLeagues = Array.from(new Map(leaguesToUpsert.map(item => [item.id, item])).values())
      await supabase.from('leagues').upsert(uniqueLeagues)
    }

    if (teamsToUpsert.length > 0) {
      const uniqueTeams = Array.from(new Map(teamsToUpsert.map(item => [item.id, item])).values())
      await supabase.from('teams').upsert(uniqueTeams)
    }

    if (matchesToUpsert.length > 0) {
      await supabase.from('matches').upsert(matchesToUpsert)
    }

    // Process Odds (Basic Example for demonstration)
    const inplayOddsResp = await fetch(`https://${API_HOST}/odds/live`, { headers: HEADERS })
    const inplayData = await inplayOddsResp.json()

    if (inplayData && inplayData.response) {
      const oddsToUpsert = []
      for (const bet of inplayData.response) {
        if (bet.fixture && bet.odds) {
          const matchWinMarket = bet.odds.find((m: any) => m.id === 1) // 1 = Match Winner usually
          if (matchWinMarket) {
             const homeVal = matchWinMarket.values.find((v: any) => v.value === "Home")?.odd
             const drawVal = matchWinMarket.values.find((v: any) => v.value === "Draw")?.odd
             const awayVal = matchWinMarket.values.find((v: any) => v.value === "Away")?.odd
             oddsToUpsert.push({
               match_id: bet.fixture.id,
               home_win: homeVal ? parseFloat(homeVal) : 0,
               draw: drawVal ? parseFloat(drawVal) : 0,
               away_win: awayVal ? parseFloat(awayVal) : 0
             })
          }
        }
      }
      if (oddsToUpsert.length > 0) {
        await supabase.from('match_odds').upsert(oddsToUpsert)
      }
    }

    return new Response(JSON.stringify({ 
      success: true, 
      processed_matches: matchesToUpsert.length 
    }), { headers: { "Content-Type": "application/json" } })

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500, headers: { "Content-Type": "application/json" } })
  }
})
