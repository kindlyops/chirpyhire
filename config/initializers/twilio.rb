# frozen_string_literal: true

telefony = Telefony.instance
if Rails.env.production?
  telefony.client = Twilio::REST::Client.new(ENV.fetch('TWILIO_ACCOUNT_SID'), ENV.fetch('TWILIO_AUTH_TOKEN'))
else
  telefony.client = Twilio::REST::Client.new(ENV.fetch('TWILIO_TEST_ACCOUNT_SID'), ENV.fetch('TWILIO_TEST_AUTH_TOKEN'))
end
