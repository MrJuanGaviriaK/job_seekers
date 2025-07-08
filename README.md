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
bundle install
rails db:setup
rails s
brew services start redis # if on macOS
bundle exec sidekiq
```

## Running the tests with COVERAGE
COVERAGE=true bundle exec rspec
