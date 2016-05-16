class AnswersController < SmsController

  def create
    if answer.valid?
      AutomatonJob.perform_later(question, "answer")
    else
      AutomatonJob.perform_later(question, "invalid_answer")
    end
    head :ok
  end

  private

  def answer
    outstanding_inquiry.create_answer(message: message)
  end

  def outstanding_inquiry
    @outstanding_inquiry ||= sender.outstanding_inquiry
  end

  def question
    outstanding_inquiry.question
  end
end
