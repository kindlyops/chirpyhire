class AnswersController < SmsController

  def create
    AnswerHandlerJob.perform_later(sender, outstanding_inquiry, params["MessageSid"])
    head :ok
  end

  private

  def outstanding_inquiry
    @outstanding_inquiry ||= sender.outstanding_inquiry
  end
end
