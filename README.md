## README

### Zero to Green

0. Install [rbenv](https://github.com/rbenv/rbenv#homebrew-on-mac-os-x) and [ruby-build](https://github.com/rbenv/ruby-build#installing-with-homebrew-for-os-x-users) to manage ruby versions.

1. Get `.env` file from a developer.
2. Install native dependencies if necessary.
```bash
brew install postgres
brew install redis
rbenv install 2.3.1
```
3. Download libraries, migrate database, run tests.
```ruby
bundle install
rails db:create
rails db:migrate
rspec
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
Localizes seed data to prospects area. Makes it easier for them to "Get it".  
`rails db:seed latitude=$latitude longitude=$longitude`  
Start Local Server:  
`foreman s`  
Tunnel For Twilio Webhook:  
`ngrok http 3000`  
Login to the app before the demo begins. They trust logging in works.
