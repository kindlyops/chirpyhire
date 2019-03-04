## README

### Zero to Green

1. Install docker and docker-compose.

2. Get `.env` file from a developer. You can use dummy keys to help run tests.
3. build containers, set up database
```bash
docker-compose up -d
docker-compose exec website rails db:create
docker-compose exec website rails db:migrate
docker-compose exec website rails db:seed
docker-compose exec website rails assets:precompile
open localhost:3000
```

### Twilio Development

Use ngrok tunnel For Twilio Webhook:
`ngrok http 3000`
Login to Twilio and set SMS Webhook URL to the Dynamic ngrok URL. [More info](https://www.twilio.com/blog/2013/10/test-your-webhooks-locally-with-ngrok.html)

### Stripe Development

Use test keys and test environment.

### Demoing App

Ensure you have a clean install:
`rails db:drop && rails db:create && rails db:migrate`
Start Local Server:
`docker-compose up -d`
Tunnel For Twilio Webhook:
`ngrok http 3000`

### To run a single rspec test

```bash
docker-compose exec website  rspec spec/models/contact_spec.rb
```

### to run the rspec tests for the reminders

```bash
docker-compose exec website rspec spec/lib/reminder/**
```

### Interactive database maintenance

To get a local rails console:

```bash
docker-compose exec website rails console
```

Find a user

```ruby
a = Account.find_by_email 'demo@chirpyhire.com'
```