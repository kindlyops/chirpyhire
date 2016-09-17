# frozen_string_literal: true
require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!

  c.filter_sensitive_data('MAPZEN_SEARCH_KEY') do
    ENV['MAPZEN_SEARCH_KEY']
  end

  c.filter_sensitive_data('OPENCAGE_KEY') do
    ENV['OPENCAGE_KEY']
  end

  c.filter_sensitive_data('TWILIO_TEST_AUTH_TOKEN') do
    ENV['TWILIO_TEST_AUTH_TOKEN']
  end

  c.filter_sensitive_data('TWILIO_TEST_ACCOUNT_SID') do
    ENV['TWILIO_TEST_ACCOUNT_SID']
  end

  c.filter_sensitive_data('ROLLBAR_ACCESS_TOKEN') do
    ENV['ROLLBAR_ACCESS_TOKEN']
  end

  c.filter_sensitive_data('SMTP_PASSWORD') do
    ENV['SMTP_PASSWORD']
  end

  c.filter_sensitive_data('DEV_PHONE') do
    ENV['DEV_PHONE']
  end

  c.filter_sensitive_data('DEV_EMAIL') do
    ENV['DEV_EMAIL']
  end

  c.filter_sensitive_data('TEST_ORG_PHONE') do
    ENV['TEST_ORG_PHONE']
  end

  c.filter_sensitive_data('SMARTY_STREETS_AUTH_TOKEN') do
    ENV['SMARTY_STREETS_AUTH_TOKEN']
  end

  c.filter_sensitive_data('STRIPE_SECRET_KEY') do
    ENV['STRIPE_SECRET_KEY']
  end

  c.filter_sensitive_data('STRIPE_WEBHOOK_SECRET') do
    ENV['STRIPE_WEBHOOK_SECRET']
  end

  c.filter_sensitive_data('STRIPE_PUBLISHABLE_KEY') do
    ENV['STRIPE_PUBLISHABLE_KEY']
  end
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
