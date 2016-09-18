# frozen_string_literal: true
class AnswerValidator
  def initialize(answer)
    @answer = answer
  end

  def validate
    unless inquiry.of?(format)
      error_message = "expected #{inquiry.question_type} but received #{format}"
      answer.errors.add(:inquiry, error_message)

      log('Unable to find naive address') if inquiry.of_address? && naive_match?
    end
  end

  private

  attr_reader :answer

  def message
    @message ||= answer.message
  end

  def naive_match?
    AddressFinder.new(message.body).naive_match?
  end

  def format
    @format ||= AnswerFormatter.new(answer, inquiry).format
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
