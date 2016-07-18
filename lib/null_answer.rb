NullAnswer = Naught.build do |config|
  config.mimic Answer

  def persona_feature
    NullPersonaFeature.new
  end
end
