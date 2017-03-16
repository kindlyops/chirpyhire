## README

### Zero to Green

0. Install [rbenv](https://github.com/rbenv/rbenv#homebrew-on-mac-os-x) and [ruby-build](https://github.com/rbenv/ruby-build#installing-with-homebrew-for-os-x-users) to manage ruby versions.

1. Get `.env` file from a developer. You can use dummy keys to help run tests.
2. Install native dependencies if necessary.
```bash
brew install postgres
brew install redis
brew install phantomjs
rbenv install 2.3.1
```
For more information on [Postgres](https://gorails.com/setup/osx/10.11-el-capitan), especially if "No such file found" when trying
to create DB. You'll likely need to change the [template](https://gist.github.com/amolkhanorkar/8706915), too. For redis, you may need to ensure the server is running with `redis-server &`.
3. Install [QT55 bindings](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit)
4. Download libraries, migrate database, run tests.
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

### Demoing App

Ensure you have a clean install:
`rails db:drop && rails db:create && rails db:migrate`
Start Local Server:
`foreman s`
Tunnel For Twilio Webhook:
`ngrok http 3000`
