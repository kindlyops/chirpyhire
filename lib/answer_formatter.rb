class AnswerFormatter
  def initialize(answer, persona_feature)
    @answer = answer
    @persona_feature = persona_feature
  end

  def format
    return "document" if message.has_images?
    return "address" if message.has_address?
    return "choice" if message.has_choice?(choices)
    "unknown format"
  end

  private

  attr_reader :answer, :persona_feature

  def choices
    return unless persona_feature.has_choices?

    persona_feature.choice_options_letters.join
  end

  def message
    @message ||= answer.message
  end
end
