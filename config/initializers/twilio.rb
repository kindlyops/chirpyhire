if Rails.env.production?
  $twilio = Twilio::REST::Client.new(ENV.fetch('TWILIO_ACCOUNT_SID'), ENV.fetch('TWILIO_AUTH_TOKEN'))
else
  $twilio = Twilio::REST::Client.new(ENV.fetch('TWILIO_TEST_ACCOUNT_SID'), ENV.fetch('TWILIO_TEST_AUTH_TOKEN'))
end
