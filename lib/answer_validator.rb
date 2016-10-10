class AnswerValidator
  def initialize(answer)
    @answer = answer
  end

  def validate
    if !inquiry.asks_question_of?(question_class)
      add_wrong_question_type_error
      if inquiry.asks_question_of?(AddressQuestion) && naive_match?
        log('Unable to find naive address')
      end
    end
  rescue AnswerClassifier::NotClassifiedError
    error_message = "expected #{inquiry.question_type}
       but wasn't classified as any question type"
    answer.errors.add(:inquiry, error_message)
  end

  private

  attr_reader :answer

  def add_wrong_question_type_error
    error_message =
      "expected #{inquiry.question_type}
       but received #{question_class.name}"
    answer.errors.add(:inquiry, error_message)
  end

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
