NullReferral = Naught.build do |config|
  config.mimic Referral

  def sms_response
    Sms::Response.error
  end
end
