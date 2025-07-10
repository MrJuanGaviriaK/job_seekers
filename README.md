# Job Seeker API

This is a Rails API-only application for job seekers and clients.

## Features

- API versioning (via `/api/v1`)
- Swagger UI docs
- Job seekers can apply to jobs
- Clients can create job opportunities
- Background jobs using Sidekiq
- Caching & pagination
- RSpec tests

---

## Running the project (Locally)

```bash
# 1. Install dependencies
bundle install

# 2. Set up the database (creates, migrates, and seeds if needed)
rails db:setup

# 3. Start Redis (required for Sidekiq background jobs)
brew services start redis  # macOS only
# OR use `redis-server` if not using Homebrew

# 4. Start the Rails server
rails s

# 5. In a separate terminal, start Sidekiq for background jobs
bundle exec sidekiqq
```

## Running the tests with COVERAGE
COVERAGE=true bundle exec rspec
