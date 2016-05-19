NullReferrer = Naught.build do |config|
  config.mimic Referrer

  def decorate
    self
  end

  def phone_number
    ""
  end

  def name
    ""
  end
end
