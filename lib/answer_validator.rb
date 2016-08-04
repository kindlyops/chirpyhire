class AnswerValidator

  def initialize(answer)
    @answer = answer
  end

  def validate
    unless inquiry.question_type == format
      answer.errors.add(:inquiry, "expected #{inquiry.question_type} but received #{format}")

      if inquiry.question_type == "AddressQuestion" && AddressFinder.new(message.body).naive_match?
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
    @format ||= AnswerFormatter.new(answer, inquiry).format
  end

  def inquiry
    @inquiry ||= answer.inquiry
  end
end
