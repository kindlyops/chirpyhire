source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use SCSS for stylesheets
gem 'bootstrap', '~> 4.0.0.beta'
gem 'sass', github: 'hwhelchel/sass', branch: 'dynamic_includes'
gem 'sass-rails', '~> 5.0.5'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

gem 'jbuilder'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'oj'

group :development, :test, :demo do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker', '~> 1.6.0'
end

group :development, :test do
  gem 'dotenv-rails', '~> 2.2.1'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.6.0'
end

group :test do
  gem 'capybara', '~> 2.14.0'
  gem 'capybara-webkit', github: 'thoughtbot/capybara-webkit', branch: 'master'
  gem 'database_cleaner', '~> 1.6.1'
  gem 'launchy', '~> 2.4.3'
  gem 'poltergeist', '~> 1.15.0'
  gem 'pundit-matchers', '~> 1.0.2'
  gem 'rails-controller-testing'
  gem 'rubocop', '~> 0.49.1'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'vcr', '~> 3.0.0'
  gem 'webmock', '~> 2.3.2'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'brakeman', '~> 3.3.0'
  gem 'bullet', '~> 5.5.1'
  gem 'listen', '~> 3.0.5'
  gem 'meta_request', '~> 0.4.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '~> 3.1.0'
end

group :production do
  gem 'rails_12factor', '~> 0.0.3'
  gem 'skylight', '~> 1.0'
end

gem 'rollbar', '~> 2.15.0'

# Authentication
gem 'devise', '~> 4.3.0'
gem 'devise_invitable', '~> 1.7.2'

# Authorization
gem 'pundit', git: 'https://github.com/elabs/pundit.git', ref: '58eda659d44a2'

# Impersonation
gem 'aasm', '~> 4.12.1'
gem 'ahoy_email', '~> 0.5.0'
gem 'aws-sdk', '~> 2.8.5'
gem 'charlock_holmes', '~> 0.7.5'
gem 'cocoon', '~> 1.2.10'
gem 'counter_culture', '~> 1.5.1'
gem 'csv_shaper', '~> 1.3.0'
gem 'draper', '~> 3.0.0'
gem 'font-awesome-rails', '~> 4.7.0'
gem 'haml', '~> 5.0.1'
gem 'heap', github: 'hwhelchel/heap-ruby', branch: 'add-timestamp-to-track'
gem 'high_voltage', '~> 3.0.0'
gem 'inline_svg', '~> 0.11.1'
gem 'intercom-rails', '~> 0.3.4'
gem 'json', '~> 2.1.0'
gem 'kaminari', '~> 0.17.0'
gem 'liquid', '~> 4.0.0'
gem 'nav_lynx', '~> 1.1.1'
gem 'nokogiri', '~> 1.7.1'
gem 'paperclip', '~> 5.1.0'
gem 'paranoia', '~> 2.3'
gem 'phony_rails', '~> 0.14.0'
gem 'premailer-rails', '~> 1.9.6'
gem 'puma', '~> 3.7'
gem 'rails_admin', github: 'sferik/rails_admin', branch: 'master'
gem 'ransack', '~> 1.8.3'
gem 'sidekiq', '~> 4.0.0'
gem 'sinatra', '~> 2.0.0'
gem 'slack-notifier', '~> 2.1.0'
gem 'slim-rails', '~> 3.1.0'
gem 'smartystreets_ruby_sdk', github: 'hwhelchel/smartystreets-ruby-sdk', branch: 'rearchitect-gem'
gem 'stripe', '~> 2.12.0'
gem 'twemoji', '~> 3.1.4'
gem 'twilio-ruby', '~> 4.13.0'
gem 'webpacker', '~> 1.2.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-clipboard', '~> 1.6.1'
  gem 'rails-assets-lodash', '~> 4.17.4'
  gem 'rails-assets-popper.js', '~> 1.12.5'
  gem 'rails-assets-ramda', '~> 0.23.0'
  gem 'rails-assets-select2', '~> 4.0.3'
end
