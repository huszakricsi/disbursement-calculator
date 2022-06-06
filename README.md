# Disbursement Calculator

## Installation

Prerequisites:

- Rails 5.2
- SQLite3
- Redis

```
        bundle install
        rails db:create
        rails db:migrate
        rails db:seed
```

Start server, redis-server and sidekiq:

```
        redis-server
        bundle exec sidekiq
        rails s
```

Run tests and generate coverage information:
```
        SIMPLECOV=true bundle exec rspec
```

## API Reference

#### Get disburseents

```
    GET /disbursements
```

| Parameter     | Type      | Description                                                          |
|---------------|-----------|----------------------------------------------------------------------|
| `year`        | `integer` | **Required**. Year value                                             |
| `week`        | `integer` | **Required**. Week value                                             |
| `merchant_id` | `integer` | Optional. Merchant ID, if not defined, returns for all merchants |

## Technical choices

The main idea here will be to pre-generate disbursements for merchants.
API requests just return values from the separated table. In this implementation when an API hit does not returns disbursement, a background job will be triggered to generate it. And on the next API call, it will return the prepared value when generated.

## Improvement ideas
In the future, it can be improved to schedule jobs each Monday night to calculate for the previous week(for example with cron). Also, test coverage and testing needs to be improved as well(e.g. A shared example for sidekiq, its a bit ugly now). I was focusing to create a minimal valuable product under 3 hours, that can fulfill the requirements you gave.
