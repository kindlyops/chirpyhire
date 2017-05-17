source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass', github: 'hwhelchel/sass', branch: 'dynamic_includes'
gem 'sass-rails', '~> 5.0.5'
gem 'bootstrap', '~> 4.0.0.alpha6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

gem 'jquery-rails'
gem 'jbuilder'
gem 'turbolinks', '~> 5.0.1'

group :development, :test, :demo do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker', '~> 1.6.0'
end

group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.5.1'
  gem 'dotenv-rails', '~> 2.2.1'
end

group :test do
  gem 'vcr', '~> 3.0.0'
  gem 'webmock', '~> 2.3.2'
  gem 'capybara', '~> 2.14.0'
  gem 'database_cleaner', '~> 1.6.1'
  gem 'launchy', '~> 2.4.3'
  gem 'capybara-email', git: 'git@github.com:DockYard/capybara-email.git', ref: 'c30c5f0'
  gem 'pundit-matchers', '~> 1.0.2'
  gem 'poltergeist', '~> 1.15.0'
  gem 'rails-controller-testing'
  gem 'timecop', '~> 0.8.1'
  gem 'capybara-webkit', github: 'thoughtbot/capybara-webkit', branch: 'master'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'rubocop', '~> 0.47.1'
end

group :development do
  gem 'web-console', '~> 3.1.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'brakeman', '~> 3.3.0'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request', '~> 0.4.2'
end

group :production do
  gem 'rails_12factor', '~> 0.0.3'
  gem 'skylight', '~> 1.0'
end

gem 'rollbar', '~> 2.14.0'

# Authentication
gem 'devise', '~> 4.3.0'
gem 'devise_invitable', '~> 1.6.0'

# Authorization
gem 'pundit', git: 'https://github.com/elabs/pundit.git', ref: '58eda659d44a2'

# Impersonation
gem 'pretender', '~> 0.2.1'
gem 'phony_rails', '~> 0.14.0'
gem 'slim-rails', '~> 3.1.0'
gem 'twilio-ruby', '~> 4.11.0'
gem 'sidekiq', '~> 4.0.0'
gem 'sinatra', '~> 2.0.0'
gem 'puma', '~> 3.4.0'
gem 'font-awesome-rails', '~> 4.7.0'
gem 'draper', '~> 3.0.0'
gem 'haml', '~> 5.0.1'
gem 'rails_admin', github: 'sferik/rails_admin', branch: 'master'
gem 'json', '~> 2.1.0'
gem 'inline_svg', '~> 0.11.1'
gem 'cocoon', '~> 1.2.9'
gem 'zip-codes', '~> 0.2.1'
gem 'kaminari', '~> 0.17.0'
gem 'nav_lynx', '~> 1.1.1'
gem 'paperclip', '~> 5.1.0'
gem 'aws-sdk', '~> 2.8.5'
gem 'smartystreets_ruby_sdk', github: 'hwhelchel/smartystreets-ruby-sdk', branch: 'rearchitect-gem'
gem 'counter_culture', '~> 1.5.1'
gem 'paranoia', '~> 2.3'
gem 'premailer-rails', '~> 1.9.6'
gem 'nokogiri', '~> 1.7.1'
gem 'ahoy_email', '~> 0.5.0'
gem 'slack-notifier', '~> 2.1.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
  gem 'rails-assets-ramda', '~> 0.23.0'
  gem 'rails-assets-clipboard', '~> 1.6.1'
end

