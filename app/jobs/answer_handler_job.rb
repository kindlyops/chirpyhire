class AnswerHandlerJob < MessageHandlerRetryJob
  def perform(sender, inquiry, message_sid,
              retries: MessageHandlerRetryJob::DEFAULT_RETRIES)
    @sender = sender
    @inquiry = inquiry
    @message_sid = message_sid
    @retries_remaining = retries

    message = MessageHandler.new(sender, message_sid).call
    AnswerHandler.new(sender, inquiry, message).call
  end

  def retry_with(job, retries)
    job.perform_later(sender, inquiry, message_sid, retries: retries)
  end

  private

  attr_accessor :sender, :inquiry, :message_sid
end
