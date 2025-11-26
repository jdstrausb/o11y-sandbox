# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Rails 8 API-mode sandbox** used for performance optimization learning and interview preparation. The codebase demonstrates common Rails performance patterns including N+1 query optimization, memory management, and async job processing with Sidekiq.

**Tech Stack:**
- Rails 8.0.2 (API-only mode)
- Ruby 3.4.2
- SQLite3
- Sidekiq 8.0 (backed by Redis)
- Puma web server

## Common Commands

### Database
```bash
# Run migrations
bin/rails db:migrate

# Reset database
bin/rails db:reset

# Seed database
bin/rails db:seed

# Load schema
bin/rails db:schema:load
```

### Testing
```bash
# Run all tests
bin/rails test

# Run a single test file
bin/rails test test/models/user_test.rb

# Run a specific test
bin/rails test test/models/user_test.rb:10
```

### Running Performance Test Scripts
```bash
# N+1 query demonstration
rails runner query_test.rb

# Memory management comparison (User.all vs User.find_each)
rails runner memory_test.rb

# Idempotency test for background jobs
rails runner idempotency_test.rb
```

### Sidekiq (Background Jobs)
```bash
# Start Sidekiq with 2 threads
bundle exec sidekiq -c 2

# Start Sidekiq in the background
bundle exec sidekiq -d

# Monitor Sidekiq (requires web UI setup)
bundle exec sidekiq
```

### Rails Console
```bash
# Start console
bin/rails console

# Enable SQL logging in console
ActiveRecord::Base.logger = Logger.new(STDOUT)
```

## Architecture & Key Concepts

### Data Models

Three primary models demonstrate performance patterns:

1. **Author ↔ Book** (One-to-Many)
   - Used to demonstrate N+1 queries
   - Test dataset: 50 Authors, 5 Books each (250 books total)
   - Location: [app/models/author.rb](app/models/author.rb), [app/models/book.rb](app/models/book.rb)

2. **User**
   - Used for memory management and async job testing
   - Contains credits system and bonus tracking
   - Location: [app/models/user.rb](app/models/user.rb)

### Performance Patterns Demonstrated

#### N+1 Query Prevention
- **Problem**: Lazy loading associations triggers N+1 queries (1 query + N additional queries)
- **Solution**: Use `.includes(:association)` for eager loading
- **Example**: See [query_test.rb](query_test.rb)
- Key methods:
  - Bad: `Author.all.each { |a| a.books.count }` → 51 queries
  - Good: `Author.includes(:books).all.each { |a| a.books.count }` → 2 queries

#### Memory Management
- **Problem**: `Model.all.each` loads entire dataset into memory (O(N) memory)
- **Solution**: Use `.find_each(batch_size: 1000)` for batched processing (O(1) memory)
- **Example**: See [memory_test.rb](memory_test.rb)
- Important: For large datasets (100K+ records), always use batching to prevent OOM kills

#### Idempotent Background Jobs
- **Problem**: Network failures cause job retries, potentially duplicating operations
- **Solution**: Check state before mutating, use transactions with locking
- **Example**: See [app/jobs/award_bonus_job.rb](app/jobs/award_bonus_job.rb)
- Pattern:
  ```ruby
  return if already_processed?
  Model.transaction do
    record.lock!
    # perform operation atomically
  end
  ```

#### Race Condition Prevention
- Use `increment!(:column, value)` instead of `update(column: column + value)`
- The `increment!` method is atomic at the database level
- Example in [app/models/user.rb](app/models/user.rb:58)

#### Ruby GVL & Concurrency
- Ruby's Global Interpreter Lock (GVL) is released during IO operations
- This means Sidekiq can efficiently handle concurrent IO-bound tasks (database queries, HTTP requests)
- See [app/jobs/clickhouse_report_job.rb](app/jobs/clickhouse_report_job.rb) for demonstration

### Active Job Configuration

Background jobs use Sidekiq as the queue adapter (configured in [config/application.rb](config/application.rb:45)):
```ruby
config.active_job.queue_adapter = :sidekiq
```

All jobs inherit from `ApplicationJob` and queue to `:default` by default.

### Code Quality Patterns

The codebase follows Rails best practices demonstrated in [app/models/user.rb](app/models/user.rb):
- Extract magic numbers to named constants
- Use guard clauses to reduce nesting
- Prefer `.size` over `.count` (leverages counter_cache if available)
- Use atomic operations (`increment!`) to prevent race conditions
- Private methods for single-responsibility principle

## Study Guide References

Three markdown study guides document the learning objectives:
- [N_PLUS_ONE_STUDY_GUIDE.md](N_PLUS_ONE_STUDY_GUIDE.md) - N+1 queries and observability
- [MEMORY_MANAGEMENT_STUDY_GUIDE.md](MEMORY_MANAGEMENT_STUDY_GUIDE.md) - Memory patterns and batching
- [ASYNC_JOBS_AND_GVL_STUDY_GUIDE.md](ASYNC_JOBS_AND_GVL_STUDY_GUIDE.md) - Sidekiq, idempotency, and GVL

These guides provide context for the code patterns and explain the "why" behind implementation choices.
