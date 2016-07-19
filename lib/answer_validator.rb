class AnswerValidator

  def initialize(answer)
    @answer = answer
  end

  def validate
    unless inquiry.format == format
      answer.errors.add(:inquiry, "expected #{inquiry.format} but received #{format}")
    end
  end

  private

  attr_reader :answer

  def format
    @format ||= AnswerFormatter.new(answer, persona_feature).format
  end

  def inquiry
    @inquiry ||= answer.inquiry
  end

  def persona_feature
    @persona_feature ||= inquiry.persona_feature
  end

end
