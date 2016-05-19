NullCandidate = Naught.build do |config|
  config.mimic Candidate

  def decorate
    self
  end
end
