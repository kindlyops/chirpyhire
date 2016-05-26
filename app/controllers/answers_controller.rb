class AnswersController < SmsController

  def create
    if answer.valid?
      AutomatonJob.perform_later(sender, trigger)
      head :ok
    else
      unknown_message
    end
  end

  private

  def answer
    sender.answer(outstanding_inquiry, params["MessageSid"])
  end

  def outstanding_inquiry
    @outstanding_inquiry ||= sender.outstanding_inquiry
  end

  def question
    outstanding_inquiry.question
  end

  def trigger
    question.trigger
  end

end
