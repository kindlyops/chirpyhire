class Choice < CandidateFeature
  def self.extract(message, persona_feature)
    properties = {}
    properties[:child_class] = "choice"

    answer = message.body.strip.downcase
    choice_option = /\A([a-z]){1}\)?\z/.match(answer)[1]
    properties[:choice_option] = persona_feature.properties['choice_options'][choice_option]
    properties
  end
end
