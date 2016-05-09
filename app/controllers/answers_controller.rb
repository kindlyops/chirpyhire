class AnswersController < SmsController

  def create
    if outstanding_inquiry.expects?(message)
      outstanding_inquiry.create_answer(message: message)
      AutomatonJob.perform_later(sender, "answer:create:#{question.id}:")
    else
      AutomatonJob.perform_later(sender, "answer:invalid:#{question.id}:")
    end
  end

  private

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
