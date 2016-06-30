class AnswersController < SmsController

  def create
    if outstanding_inquiry.present?
      AnswerHandlerJob.perform_later(sender, outstanding_inquiry, params["MessageSid"])
      head :ok
    else
      unknown_chirp
    end
  end

  private

  def outstanding_inquiry
    @outstanding_inquiry ||= sender.outstanding_inquiry
  end
end
