class AnswersController < SmsController

  def create
    if answer.valid?
      AutomatonJob.perform_later(sender, question, "answer")
    else
      AutomatonJob.perform_later(sender, question, "invalid_answer")
    end
  end

  private

  def answer
    outstanding_inquiry.create_answer(message: message)
  end

  def sender
    user.candidate
  end

  def outstanding_inquiry
    sender.outstanding_inquiry
  end

  def question
    outstanding_inquiry.question
  end
end
