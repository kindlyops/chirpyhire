class AnswersController < SmsController

  def create
    if answer.valid?
      ProfileJob.perform_later(sender.candidate, profile)
      head :ok
    else
      unknown_message
    end
  end

  private

  def answer
    @answer ||= sender.answer(outstanding_inquiry, params["MessageSid"])
  end

  def outstanding_inquiry
    @outstanding_inquiry ||= sender.outstanding_inquiry
  end

  def profile
    organization.profile
  end
end
