require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data('MAPZEN_SEARCH_KEY') { ENV['MAPZEN_SEARCH_KEY'] }
  c.filter_sensitive_data('OPENCAGE_KEY') { ENV['OPENCAGE_KEY'] }
  c.filter_sensitive_data('TWILIO_TEST_AUTH_TOKEN') { ENV['TWILIO_TEST_AUTH_TOKEN'] }
  c.filter_sensitive_data('TWILIO_TEST_ACCOUNT_SID') { ENV['TWILIO_TEST_ACCOUNT_SID'] }
  c.filter_sensitive_data('ROLLBAR_ACCESS_TOKEN') { ENV['ROLLBAR_ACCESS_TOKEN'] }
  c.filter_sensitive_data('SMTP_PASSWORD') { ENV['SMTP_PASSWORD'] }
  c.filter_sensitive_data('DEV_PHONE') { ENV['DEV_PHONE'] }
  c.filter_sensitive_data('DEV_EMAIL') { ENV['DEV_EMAIL'] }
  c.filter_sensitive_data('TEST_ORG_PHONE') { ENV['TEST_ORG_PHONE'] }
  c.filter_sensitive_data('SMARTY_STREETS_AUTH_TOKEN') { ENV['SMARTY_STREETS_AUTH_TOKEN'] }
end

RSpec.configure do |config|
  config.before(:each, js: true) do
    VCR.configure do |c|
      c.ignore_request do |request|
        URI(request.uri).port == Capybara.server_port
      end
    end
  end
end
