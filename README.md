# O11y-sandbox

A Full-Stack Observability Playground built for performance engineering.

**Stack:**
- **Backend:** Ruby on Rails 8 (API Mode), SQLite, Sidekiq
- **Frontend:** Vue 3, Composition API, Tailwind CSS, Vite (bundled via Bun)
- **Visualization:** ECharts, vue-virtual-scroller

**Key Features:**
- **High-Performance Logs:** Renders 50k+ log lines using Virtual Scrolling and `shallowRef` optimization.
- **N+1 Optimization:** Demonstrates eager loading patterns in Rails.
- **Async Processing:** Sidekiq job handling with idempotency patterns.
- **Design:** Dark-mode capable UI with dynamic CSS variable binding.

## Setup

1. **Backend:**
   ```bash
   bundle install
   bin/rails db:setup
   bin/rails s
   ```

2. **Frontend:**
   ```bash
   cd frontend
   bun install
   bun run dev
   ```
