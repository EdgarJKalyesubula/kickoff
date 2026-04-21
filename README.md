# ⚽ Kickoff — Live Football Dashboard

Kickoff is a high-performance, real-time football betting dashboard. Originally a static mockup, it has been transformed into a fully dynamic web application powered by **Supabase**. It features automated live data syncing, regional affiliate partner detection, and a premium, responsive UI.

## 🏗️ Architecture

The platform is split into a **Thin Client Frontend** and a **Cloud Backend Ecosystem**:

- **Frontend**: Vanilla JS, HTML5, and CSS3. Utilizes `Supabase Realtime` for instant score updates and `ipapi` for geolocation.
- **Backend (Supabase)**:
  - **PostgreSQL**: Stores matches, team data, league standings, top scorers, and betting partners.
  - **Edge Functions**: A Deno Edge Function (`sync-football-data`) polls live data from **API-Football**.
  - **Automated Scheduling**: Managed via `pg_cron` inside the database to keep the data fresh without manual intervention.

## ✨ Key Features

- **Live Score Tracking**: Automated updates for Champions League, Premier League, La Liga, and more.
- **Dynamic Affiliate Routing**: Automatically detects your country and displays the highest-rated licensed bookmakers (e.g., Betway, SportPesa, DraftKings).
- **Region Safeguards**: Identifies restricted regions to ensure legal compliance.
- **Real-time Match Odds**: Live fluctuating odds based on match events.

## 🚀 Development Setup

### 1. Prerequisite
- A **Supabase** project.
- An **API-Football** key from [api-sports.io](https://api-sports.io/).

### 2. Environment Configuration
Set your API key in your Supabase environment:
```bash
supabase secrets set API_FOOTBALL_KEY=your_key_here
```

### 3. Deploy Backend
```bash
supabase link --project-ref your_project_id
supabase db push
supabase functions deploy sync-football-data
```

## 👨‍💻 Credits

The core backend architecture and Supabase integration were built by **Daudi Makumbi**.

- **GitHub**: [DaudiKi](https://github.com/DaudiKi)
- **Repo Collaborator**: [EdgarJKalyesubula](https://github.com/EdgarJKalyesubula)

---
*Built 2026*
