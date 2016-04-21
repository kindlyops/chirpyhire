NullReferrer = Naught.build do |config|
  config.mimic Referrer

  def phone_number
    ""
  end

  def name
    ""
  end
end
