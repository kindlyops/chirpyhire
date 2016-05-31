class AnswersController < SmsController

  def create
    if answer.valid?
      AutomatonJob.perform_later(sender, "answer")
      head :ok
    else
      unknown_message
    end
  end

  private

  def answer
    @answer ||= sender.answer(outstanding_inquiry, params)
  end

  def outstanding_inquiry
    @outstanding_inquiry ||= sender.outstanding_inquiry
  end
end
