class AnswerValidator

  def initialize(answer)
    @answer = answer
  end

  def validate
    unless inquiry.format == format
      answer.errors.add(:inquiry, "expected #{inquiry.format} but received #{format}")

      if inquiry.format == "address" && AddressFinder.new(message.body).naive_match?
        Rollbar.debug("Unable to find naive address", id: message.id, body: message.body)
      end
    end
  end

  private

  attr_reader :answer

  def message
    @message ||= answer.message
  end

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
