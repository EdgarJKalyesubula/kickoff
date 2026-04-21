-- Phase 2 Seed Data (Teams, Leagues, Standings, Scorers)

-- 1. Seeding Leagues
INSERT INTO leagues (id, code, label, season) VALUES
  (39, 'pl', 'Premier League', '2024'),
  (2, 'ucl', 'Champions League', '2024'),
  (140, 'laliga', 'La Liga', '2024'),
  (78, 'bundesliga', 'Bundesliga', '2024'),
  (135, 'seriea', 'Serie A', '2024'),
  (61, 'ligue1', 'Ligue 1', '2024')
ON CONFLICT (id) DO NOTHING;

-- 2. Seeding Teams
INSERT INTO teams (id, name, short_name, flag_url) VALUES
  -- Clubs
  (50, 'Manchester City', 'MCI', '🔵'),
  (40, 'Liverpool', 'LIV', '🔴'),
  (42, 'Arsenal', 'ARS', '🔴'),
  (49, 'Chelsea', 'CHE', '🔵'),
  (33, 'Manchester United', 'MUN', '🔴'),
  (47, 'Tottenham', 'TOT', '⚪'),
  (541, 'Real Madrid', 'RMA', '⚪'),
  (529, 'Barcelona', 'BAR', '🔵'),
  (530, 'Atletico Madrid', 'ATM', '🔴'),
  (157, 'Bayern Munich', 'BAY', '🔴'),
  (165, 'Borussia Dortmund', 'DOR', '🟡'),
  (505, 'Inter Milan', 'INT', '🔵'),
  (496, 'Juventus', 'JUV', '⚫'),
  (85, 'Paris Saint Germain', 'PSG', '🔵')
ON CONFLICT (id) DO NOTHING;

-- 3. Seeding Standings
INSERT INTO standings (league_id, team_id, ranking, played, won, drawn, lost, goals_for, goals_against, points, status) VALUES
  -- Premier League (id 39)
  (39, 50, 1, 32, 23, 5, 4, 72, 30, 74, 'ucl'),
  (39, 40, 2, 32, 22, 6, 4, 68, 33, 72, 'ucl'),
  (39, 42, 3, 32, 21, 7, 4, 65, 28, 70, 'ucl'),
  (39, 49, 4, 32, 16, 8, 8, 52, 42, 56, 'ucl'),
  (39, 47, 5, 32, 14, 6, 12, 50, 52, 48, 'uel'),
  (39, 33, 6, 32, 10, 8, 14, 38, 52, 38, ''),
  
  -- La Liga (id 140)
  (140, 541, 1, 30, 23, 4, 3, 72, 25, 73, 'ucl'),
  (140, 529, 2, 30, 21, 5, 4, 68, 30, 68, 'ucl'),
  (140, 530, 3, 30, 18, 7, 5, 54, 28, 61, 'ucl'),
  
  -- Bundesliga (id 78)
  (78, 157, 1, 28, 22, 3, 3, 78, 28, 69, 'ucl'),
  (78, 165, 2, 28, 16, 5, 7, 56, 40, 53, 'ucl');

-- 4. Seeding Scorers
INSERT INTO scorers (league_id, team_id, player_name, goals, assists) VALUES
  -- Premier League
  (39, 50, 'Erling Haaland (🇳🇴)', 28, 6),
  (39, 40, 'Mohamed Salah (🇪🇬)', 22, 14),
  (39, 42, 'Bukayo Saka (🏴󠁧󠁢󠁥󠁮󠁧󠁿)', 17, 12),
  (39, 49, 'Cole Palmer (🏴󠁧󠁢󠁥󠁮󠁧󠁿)', 16, 10),
  (39, 50, 'Phil Foden (🏴󠁧󠁢󠁥󠁮󠁧󠁿)', 14, 8),
  
  -- Champions League (2)
  (2, 157, 'Harry Kane (🏴󠁧󠁢󠁥󠁮󠁧󠁿)', 12, 4),
  (2, 541, 'Kylian Mbappe (🇫🇷)', 10, 5),
  (2, 541, 'Vinicius Jr. (🇧🇷)', 9, 7),
  
  -- La Liga (140)
  (140, 541, 'Kylian Mbappe (🇫🇷)', 24, 8),
  (140, 529, 'Robert Lewandowski (🇵🇱)', 20, 5);
