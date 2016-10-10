class AnswerValidator
  def initialize(answer)
    @answer = answer
  end

  def validate
    unless inquiry.asks_question_of?(question_class)
      error_message =
        "expected #{inquiry.question_type}
         but received #{question_class.name}"
      answer.errors.add(:inquiry, error_message)

      if inquiry.asks_question_of?(AddressQuestion) && naive_match?
        log('Unable to find naive address')
      end
    end
  rescue AnswerClassifier::NotClassifiedError
    error_message =
      "expected #{inquiry.question_type}
       but wasn't classified as any question type"
    answer.errors.add(:inquiry, error_message)
  end

  private

  attr_reader :answer

  def message
    @message ||= answer.message
  end

  def naive_match?
    AddressFinder.new(message.body).naive_match?
  end

  def question_class
    @question_class ||= AnswerClassifier.new(answer, inquiry).classify
  end

  def inquiry
    @inquiry ||= answer.inquiry
  end

  def log(log_message)
    Rollbar.debug(
      log_message,
      id: message.id,
      body: message.body
    )
  end
end
