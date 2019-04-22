## README

### Zero to Green

1. Install xcode command line tools and homebrew
1. `brew install rbenv ruby-build`
1. Follow printed instructions on activating rbenv in your shell
1. `rbenv install 2.6.2`
1. `git clone git@github.com:kindlyops/chirpyhire.git`
1. `cd chirpyhire`
1. `ruby -v` should show version 2.6.2. `which ruby` should show an rbenv path similar to `/Users/emurphy/.rbenv/shims/ruby`
1. `gem install foreman`
1. `gem install bundler`
1. `brew install phantomjs` TODO: other needed dependencies for nokogiri, etc
1. install Qt for capybara gem (later we will need to migrate off of capybara). Instructions at https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit#homebrew
1. The main goal of all these dependencies is to be able to run `bundle install` and have it complete successfully. We will need to run this a few times to uncover additional dependencies that need to be installed and add them to the instructions.

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

### Notes on running outside of docker

    $ brew install readline ruby-build
    $ RUBY_CONFIGURE_OPTS=--with-readline-dir=`brew --prefix readline` rbenv install 2.3.1

Also you have to run `foreman start -f Procfile.dev` before running rspec in order for the 2
account management specs to pass, they seem to require maybe cable running?

### Notes on migrating away from capybara

https://artsy.github.io/blog/2018/11/27/switch-from-capybara-webkit-to-chrome/
