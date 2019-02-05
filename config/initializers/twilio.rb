if Rails.env.production?

  Messaging::Client.master = Twilio::REST::Client.new(
    ENV.fetch('TWILIO_ACCOUNT_SID'), ENV.fetch('TWILIO_AUTH_TOKEN')
  )
  Messaging::Client.client = ENV.fetch('MESSAGING_CLIENT').constantize

end