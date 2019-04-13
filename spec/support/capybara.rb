require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/webkit'

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, inspector: true)
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

Capybara::Webkit.configure(&:allow_unknown_urls)

Capybara.javascript_driver = :poltergeist
Capybara.server_port = 8080
Capybara.app_host = 'http://localhost:8080'
Capybara.save_path = Dir.pwd

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :feature
  config.before :suite do
    Warden.test_mode!
  end
  config.after :each do
    Warden.test_reset!
  end
end
