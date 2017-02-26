source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.5'
gem 'bootstrap', '~> 4.0.0.alpha6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

gem 'jquery-rails'
gem 'jbuilder'
gem 'turbolinks', '~> 5.0.0'

group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.5.1'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker', '~> 1.6.0'
  gem 'dotenv-rails', '~> 2.1.0'
end

group :test do
  gem 'vcr', '~> 3.0.0'
  gem 'webmock', '~> 2.3.2'
  gem 'capybara', '~> 2.7.0'
  gem 'database_cleaner', '~> 1.5.0'
  gem 'launchy', '~> 2.4.3'
  gem 'capybara-email', git: 'git@github.com:DockYard/capybara-email.git', ref: 'c30c5f0'
  gem 'pundit-matchers', '~> 1.0.2'
  gem 'poltergeist', '~> 1.10.0'
  gem 'rails-controller-testing'
  gem 'timecop', '~> 0.8.1'
  gem 'capybara-webkit', '~> 1.12.0'
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
  gem 'meta_request', '~> 0.4.0'
end

group :production do
  gem 'rails_12factor', '~> 0.0.3'
  gem 'skylight', '~> 1.0'
end

gem 'rollbar', '~> 2.14.0'

# Authentication
gem 'devise', '~> 4.2.0'
gem 'devise_invitable', '~> 1.6.0'

# Authorization
gem 'pundit', git: 'https://github.com/elabs/pundit.git', ref: '58eda659d44a2'

# Impersonation
gem 'pretender', '~> 0.2.1'

gem 'activemodel-serializers-xml', github: 'rails/activemodel-serializers-xml'
gem 'phony_rails', '~> 0.14.0'
gem 'slim-rails', '~> 3.1.0'
gem 'twilio-ruby', '~> 4.11.0'
gem 'sidekiq', '~> 4.0.0'
gem 'sinatra', '~> 2.0.0.beta2'
gem 'puma', '~> 3.4.0'
gem 'aasm', '~> 4.11.1'
gem 'font-awesome-rails', '~> 4.7.0'
gem 'draper', '~> 3.0.0.pre1'
gem 'rails_admin', '~> 1.1.1'
gem 'stripe', '~> 1.49.0'
gem 'stripe_event', github: 'integrallis/stripe_event', ref: '1da7ed8'
gem 'json', '~> 2.0.2'
gem 'inline_svg', '~> 0.11.1'
gem 'cocoon', '~> 1.2.9'
gem 'geocoder', '~> 1.4.3'
gem 'zip-codes', '~> 0.2.1'
gem 'bootstrap-table-rails', github: 'hwhelchel/bootstrap-table-rails', branch: '1.11.1'
gem 'kaminari', '~> 0.17.0'
gem 'csv_shaper', '~> 1.3.0'
gem 'nav_lynx', '~> 1.1.1'
gem 'pg_search', '~> 2.0.1'
gem 'hairtrigger', '~> 0.2.18'
gem 'amatch', '~> 0.3.0'
gem 'fuzzy_match', github: 'rlue/fuzzy_match'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
  gem 'rails-assets-ramda', '~> 0.23.0'
end

