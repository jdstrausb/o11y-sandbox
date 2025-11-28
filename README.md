# O11y-sandbox

A Full-Stack Observability Playground built for performance engineering.

**Stack:**
- **Backend:** Ruby on Rails 8 (API Mode), SQLite, Sidekiq
- **Frontend:** Vue 3, Composition API, Tailwind CSS, Vite (bundled via Bun)
- **Visualization:** ECharts, vue-virtual-scroller

## Key Features

### 1. Capstone Dashboard (End-to-End)
A production-ready log viewer connecting the Rails API to the Vue Frontend.
- **Backend:** 
  - `LogEntry` model with database indices on timestamp/severity for O(log N) filtering.
  - Efficient offset/limit pagination to handle large datasets.
  - CORS configuration permitting local frontend access.
- **Frontend:**
  - **State:** Uses `shallowRef` to minimize reactivity overhead for immutable log arrays.
  - **UX:** Skeleton loading states (`animate-pulse`) to reduce layout shift.
  - **Visuals:** Conditional Tailwind styling based on log severity (Red for Fatal/Error).

### 2. Performance Patterns (Sandbox Drills)
- **High-Performance UI:** Renders 50k+ log lines using `vue-virtual-scroller`.
- **N+1 Optimization:** Demonstrates eager loading solutions in Rails (`includes` vs `all`).
- **Memory Management:** Examples of batch processing (`find_each`) vs loading all records.
- **Async Processing:** Sidekiq job handling with idempotency patterns and race condition prevention.

## Setup

### 1. Backend (Rails)
Ensure you seed the database to generate the 10,000 log entries required for the Capstone dashboard.

```bash
bundle install
bin/rails db:prepare  # Migrates and runs db:seed
bin/rails s           # Runs on http://localhost:3000
```

*Note: If you need to reset data, run `bin/rails db:reset`.*

### 2. Frontend (Vue)
The frontend proxy is configured to hit port 3000.

```bash
cd frontend
bun install
bun run dev           # Runs on http://localhost:5173
```

## Project Structure

- **Backend Logic:**
  - API Controller: `app/controllers/api/v1/log_entries_controller.rb`
  - Model: `app/models/log_entry.rb`
  - Performance Tests: `query_test.rb`, `memory_test.rb`

- **Frontend Components:**
  - Capstone Dashboard: `src/components/CapstoneDashboard.vue`
  - Virtual Scroll Demo: `src/components/LogList.vue`
  - Charting Demo: `src/components/MetricChart.vue`
