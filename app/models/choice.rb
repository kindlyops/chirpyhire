class Choice < CandidateFeature
  def self.extract(message)
    properties[:child_class] = "choice"
    properties[:choice_option] = message.body
    properties
  end
end
