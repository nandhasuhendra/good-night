# User Sleep Tracker (Good Night)

A simple API based application to users track their sleep duration and get the report from following users

# MVP Features

1. Clock-in and Clock-out operation, to track the sleep duration
2. User can follow and unfollow other users
3. User can see the report of their following users

# Getting Started

## Prerequisites

1. Ruby: 3.3.0
2. Rails: 8.0
3. Postgres: >=9.5
4. Redis: >=4.0

## Setup and Configuration

1. Clone the repository

```bash
git clone git@github.com:nandhasuhendra/good-night.git
```

2. Install dependencies

```bash
bundle install
```

3. Create and setup the database

```bash
bundle exec rails db:setup
```

3.1. Run the migrations

```bash
bundle exec rails db:migrate
```

3.2. Run the seed data

```bash
# To create dummy data
DUMMY_DATA=true bundle exec rails db:seed

# To create high volume of user data (1000 users)
PERFORMANCE_TEST_PURPOSES=true bundle exec rails db:seed
```

4. Start the Rails server

```bash
bundle exec rails s
```

Your application should now be running at `http://localhost:3000`.

## K6 Load Testing

1. Install K6

```bash
https://grafana.com/docs/k6/latest/set-up/install-k6/
```

2. Run the K6 script

```bash
k6 run --summary-trend-stats="med,p(75),p(95),p(99.9)" k6/follow_unfollow_test.js
k6 run --summary-trend-stats="med,p(75),p(95),p(99.9)" k6/clock_in_and_clock_out_user.js
k6 run --summary-trend-stats="med,p(75),p(95),p(99.9)" k6/fetch_weekly_sleep_histories.js
```

## API Documentation

1. User authentication

This application need authentication to access the API. To authenticate, you can use the following

API endpoint: `POST /api/v1/login`

### Request

```bash
curl -X POST http://localhost:3000/api/v1/login \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d '{ "name" : "User1", "password": "password" }'
```

| Params   | Description | Required |
| -------- | ----------- | -------- |
| name     | User name   | Yes      |
| password | Password    | Yes      |

### Response

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0LCJleHAiOjE3NDA5Nzg1MTh9.lHCqQbvQQRiNbK3Iez7caVAj7Yp6eirBkuiLZndWgN0"
}
```

2. User follow and unfollow

2.1 Follow user

API endpoint: `POST /api/v1/users/1/follow`

### Request

```bash
curl -X POST http://localhost:3000/api/v1/users/1/follow \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer <token>"
```

| Params  | Description | Required |
| ------- | ----------- | -------- |
| user_id | User ID     | Yes      |

## Response

```json
{
  "data": {
    "id": 3746,
    "followed_id": 5,
    "following_id": 4,
    "created_at": "2025-03-03T12:09:34.353+08:00",
    "updated_at": "2025-03-03T12:09:34.353+08:00"
  }
}
```

2.2 Unfollow user

API endpoint: `DELETE /api/v1/users/1/follow`

### Request

```bash
curl -X DELETE http://localhost:3000/api/v1/users/1/unfollow \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer <token>"
```

| Params  | Description | Required |
| ------- | ----------- | -------- |
| user_id | User ID     | Yes      |

### Response

Return 204 No Content

3. User clock-in and clock-out

3.1 Clock-in

API endpoint: `POST /api/v1/user/clock_in`

### Request

```bash
curl -X POST http://localhost:3000/api/v1/user/clock_in \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer <token>"
```

### Response

```json
{
  "data": {
    "id": 1728,
    "user_name": "User3",
    "clock_in_at": "2025-03-03T12:12:07.435+08:00",
    "clock_out_at": null,
    "sleep_duration": null,
    "created_at": "2025-03-03T12:12:07.475+08:00",
    "updated_at": "2025-03-03T12:12:07.475+08:00"
  }
}
```

3.2 Clock-out

API endpoint: `PATCH /api/v1/user/clock_out`

### Request

```bash
curl -X PUT http://localhost:3000/api/v1/user/clock_out \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer <token>"
```

### Response

```json
{
  "data": {
    "id": 1728,
    "user_name": "User3",
    "clock_in_at": "2025-03-03T12:12:07.435+08:00",
    "clock_out_at": "2025-03-03T12:12:56.352+08:00",
    "sleep_duration": 48,
    "created_at": "2025-03-03T12:12:07.475+08:00",
    "updated_at": "2025-03-03T12:12:56.378+08:00"
  }
}
```

4. User report

API endpoint: `GET /api/v1/user/following/sleep_histories`

### Request

```bash
curl -X GET http://localhost:3000/api/v1/user/following/sleep_histories \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer <token>"
```

| Query Params | Description    | Default |
| ------------ | -------------- | ------- |
| page         | Page number    | 1       |
| limit        | Limit per page | 25      |

### Response

```json
{
  "data": [
    {
      "id": 1225,
      "user_name": "User48",
      "clock_in_at": "2025-03-03T02:02:35.548+08:00",
      "clock_out_at": "2025-03-03T02:02:45.025+08:00",
      "sleep_duration": 9,
      "created_at": "2025-03-03T02:02:35.552+08:00",
      "updated_at": "2025-03-03T02:02:45.034+08:00"
    },
    {
      "id": 1050,
      "user_name": "User638",
      "clock_in_at": "2025-03-03T01:55:10.410+08:00",
      "clock_out_at": "2025-03-03T01:55:19.895+08:00",
      "sleep_duration": 9,
      "created_at": "2025-03-03T01:55:10.415+08:00",
      "updated_at": "2025-03-03T01:55:19.898+08:00"
    },
    {
      "id": 1654,
      "user_name": "User2",
      "clock_in_at": "2025-03-03T10:39:46.619+08:00",
      "clock_out_at": "2025-03-03T10:39:55.270+08:00",
      "sleep_duration": 8,
      "created_at": "2025-03-03T10:39:46.625+08:00",
      "updated_at": "2025-03-03T10:39:55.276+08:00"
    },
    {
      "id": 61,
      "user_name": "User559",
      "clock_in_at": "2025-03-03T01:42:16.537+08:00",
      "clock_out_at": "2025-03-03T01:42:18.609+08:00",
      "sleep_duration": 2,
      "created_at": "2025-03-03T01:42:16.545+08:00",
      "updated_at": "2025-03-03T01:42:18.611+08:00"
    },
    {
      "id": 66,
      "user_name": "User24",
      "clock_in_at": "2025-03-03T01:42:17.063+08:00",
      "clock_out_at": "2025-03-03T01:42:19.663+08:00",
      "sleep_duration": 2,
      "created_at": "2025-03-03T01:42:17.068+08:00",
      "updated_at": "2025-03-03T01:42:19.665+08:00"
    }
  ],
  "paginate": {
    "page": 1,
    "next_page": 2,
    "prev_page": null,
    "total_page": 199,
    "limit": 5
  }
}
```
