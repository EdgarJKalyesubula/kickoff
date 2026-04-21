-- 1. Ensure required extensions are active
CREATE EXTENSION IF NOT EXISTS pg_cron;
CREATE EXTENSION IF NOT EXISTS pg_net;

-- 2. Schedule the Edge Function
-- This command will schedule a post request using pg_net every 5 minutes
-- Note: Replace the Authorization Bearer token with the appropriate Anon or Service_Role key
SELECT cron.schedule(
  'invoke-sync-football-data',
  '*/5 * * * *', -- Schedule to run every 5 minutes
  $$
    SELECT net.http_post(
        url:='https://lxdfhfluigyzzskjmisr.supabase.co/functions/v1/sync-football-data',
        headers:='{
            "Content-Type": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx4ZGZoZmx1aWd5enpza2ptaXNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY3MjgzODcsImV4cCI6MjA5MjMwNDM4N30.BX_0z-cpLEhQepJtv4tOFGTNsWiQj8w82E1SPQahQ7U"
        }'::jsonb,
        body:='{}'::jsonb
    )
  $$
);
