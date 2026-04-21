-- Update sync schedule to 15 minutes
-- 1. Unschedule the old 5-minute job
SELECT cron.unschedule('invoke-sync-football-data');

-- 2. Schedule the new 15-minute job
SELECT cron.schedule(
  'invoke-sync-football-data',
  '*/15 * * * *', -- Every 15 minutes
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
