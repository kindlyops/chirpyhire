class AnswersController < SmsController

  def create
    if answer.valid?
      AutomatonJob.perform_later(sender, question, "answer")
    end
    head :ok
  end

  private

  def answer
    outstanding_inquiry.create_answer(user: sender, message_sid: params["MessageSid"])
  end

  def outstanding_inquiry
    @outstanding_inquiry ||= sender.outstanding_inquiry
  end

  def question
    outstanding_inquiry.question
  end
end
