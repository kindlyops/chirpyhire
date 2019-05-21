## README

### Zero to Green

1. Install xcode command line tools and homebrew
1. `brew install rbenv ruby-build libpq readline`
1. Follow printed instructions on activating rbenv in your shell
1. `RUBY_CONFIGURE_OPTS=--with-readline-dir=`brew --prefix readline` rbenv install 2.6.2`
1. `git clone git@github.com:kindlyops/chirpyhire.git`
1. `cd chirpyhire`
1. `ruby -v` should show version 2.6.2. `which ruby` should show an rbenv path similar to `/Users/emurphy/.rbenv/shims/ruby`
1. `gem install foreman`
1. `gem install bundler`
2. bundle config --local build.pg --with-opt-dir="/usr/local/opt/libpq"
3. `bundle install --without=test`
4. npm install

### Set up PostgreSQL and Redis

1. brew install redis (remember to start redis)
2. set up https://postgresapp.com with PostgreSQL 10


### Experimental docker alternatives

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
### Demoing App

Ensure you have a clean install:
`rails db:drop && rails db:create && rails db:migrate && rails db:seed`
Start Local Server:
`foreman start -f Procfile.dev`


### To get tests running
1. `brew cask install phantomjs` TODO: other needed dependencies for nokogiri, etc
2. install Qt for capybara gem (later we will need to migrate off of capybara). Instructions at https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit#homebrew
3. The main goal of all these dependencies is to be able to run `bundle install` and have it complete successfully. We will need to run this a few times to uncover additional dependencies that need to be installed and add them to the instructions.

### Twilio Development

Use ngrok tunnel For Twilio Webhook:
`ngrok http 3000`
Login to Twilio and set SMS Webhook URL to the Dynamic ngrok URL. [More info](https://www.twilio.com/blog/2013/10/test-your-webhooks-locally-with-ngrok.html)

### Stripe Development

Use test keys and test environment.

### To run a single rspec test

```bash
rspec spec/models/contact_spec.rb
```

### to run the rspec tests for the reminders

```bash
rspec spec/lib/reminder/**
```

### Interactive database maintenance

To get a local rails console:

```bash
rails console
```

Find a user

```ruby
a = Account.find_by_email 'demo@chirpyhire.com'
```

### Notes on migrating away from capybara

https://artsy.github.io/blog/2018/11/27/switch-from-capybara-webkit-to-chrome/
