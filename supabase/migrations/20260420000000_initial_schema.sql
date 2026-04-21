-- Create Tables

-- LEAGUES
CREATE TABLE leagues (
  id integer PRIMARY KEY, -- API-Football ID
  code varchar(50) UNIQUE,
  label varchar(255),
  season varchar(50)
);

-- TEAMS
CREATE TABLE teams (
  id integer PRIMARY KEY, -- API-Football ID
  name varchar(255),
  short_name varchar(50),
  flag_url varchar(1000)
);

-- MATCHES
CREATE TABLE matches (
  id integer PRIMARY KEY, -- API-Football fixture ID
  league_id integer REFERENCES leagues(id) ON DELETE CASCADE,
  status varchar(50), -- e.g. UPCOMING, LIVE, FT
  minute integer,
  home_team_id integer REFERENCES teams(id) ON DELETE CASCADE,
  away_team_id integer REFERENCES teams(id) ON DELETE CASCADE,
  home_score integer,
  away_score integer,
  venue_name varchar(255),
  kickoff_time timestamp with time zone,
  created_at timestamp with time zone DEFAULT now()
);

-- MATCH ODDS
CREATE TABLE match_odds (
  match_id integer PRIMARY KEY REFERENCES matches(id) ON DELETE CASCADE,
  home_win numeric,
  draw numeric,
  away_win numeric,
  btts_yes numeric,
  btts_no numeric
);

-- MATCH EVENTS
CREATE TABLE match_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id integer REFERENCES matches(id) ON DELETE CASCADE,
  minute integer,
  type varchar(50), -- goal, yellow, red, sub, var, pen
  team_id integer REFERENCES teams(id) ON DELETE CASCADE,
  player_name varchar(255),
  detail text
);

-- STANDINGS
CREATE TABLE standings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  league_id integer REFERENCES leagues(id) ON DELETE CASCADE,
  team_id integer REFERENCES teams(id) ON DELETE CASCADE,
  ranking integer,
  played integer DEFAULT 0,
  won integer DEFAULT 0,
  drawn integer DEFAULT 0,
  lost integer DEFAULT 0,
  goals_for integer DEFAULT 0,
  goals_against integer DEFAULT 0,
  points integer DEFAULT 0,
  status varchar(50) -- e.g. ucl, uel, rel
);

-- SCORERS
CREATE TABLE scorers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  league_id integer REFERENCES leagues(id) ON DELETE CASCADE,
  team_id integer REFERENCES teams(id) ON DELETE CASCADE,
  player_name varchar(255),
  goals integer DEFAULT 0,
  assists integer DEFAULT 0
);

-- AFFILIATE PARTNERS
CREATE TABLE affiliate_partners (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  country_code varchar(10),
  currency varchar(10),
  name varchar(255),
  logo_emoji varchar(50),
  url varchar(1000),
  bonus varchar(500),
  tag varchar(500)
);

-- RLS POLICIES

-- Enable RLS on all tables
ALTER TABLE leagues ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE match_odds ENABLE ROW LEVEL SECURITY;
ALTER TABLE match_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE standings ENABLE ROW LEVEL SECURITY;
ALTER TABLE scorers ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_partners ENABLE ROW LEVEL SECURITY;

-- Allow public read access to all these tables
CREATE POLICY "Public read access on leagues" ON leagues FOR SELECT TO public USING (true);
CREATE POLICY "Public read access on teams" ON teams FOR SELECT TO public USING (true);
CREATE POLICY "Public read access on matches" ON matches FOR SELECT TO public USING (true);
CREATE POLICY "Public read access on match_odds" ON match_odds FOR SELECT TO public USING (true);
CREATE POLICY "Public read access on match_events" ON match_events FOR SELECT TO public USING (true);
CREATE POLICY "Public read access on standings" ON standings FOR SELECT TO public USING (true);
CREATE POLICY "Public read access on scorers" ON scorers FOR SELECT TO public USING (true);
CREATE POLICY "Public read access on affiliate_partners" ON affiliate_partners FOR SELECT TO public USING (true);
