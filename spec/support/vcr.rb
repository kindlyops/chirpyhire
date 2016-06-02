require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data('MAPZEN_KEY') { ENV['MAPZEN_KEY'] }
  c.filter_sensitive_data('TWILIO_TEST_AUTH_TOKEN') { ENV['TWILIO_TEST_AUTH_TOKEN'] }
  c.filter_sensitive_data('TWILIO_AUTH_TOKEN') { ENV['TWILIO_AUTH_TOKEN'] }
  c.filter_sensitive_data('ROLLBAR_ACCESS_TOKEN') { ENV['ROLLBAR_ACCESS_TOKEN'] }
  c.filter_sensitive_data('SMTP_PASSWORD') { ENV['SMTP_PASSWORD'] }
  c.filter_sensitive_data('DEV_PHONE') { ENV['DEV_PHONE'] }
  c.filter_sensitive_data('DEV_EMAIL') { ENV['DEV_EMAIL'] }
  c.filter_sensitive_data('TEST_ORG_PHONE') { ENV['TEST_ORG_PHONE'] }
  c.filter_sensitive_data('SMARTY_STREETS_AUTH_TOKEN') { ENV['SMARTY_STREETS_AUTH_TOKEN'] }
end
