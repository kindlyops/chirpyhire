class MessageHandlerJob < MessageHandlerRetryJob
  def perform(sender, message_sid,
              retries: MessageHandlerRetryJob::DEFAULT_RETRIES)
    @sender = sender
    @message_sid = message_sid
    @retries_remaining = retries

    MessageHandler.new(sender, message_sid).call
  end

  def retry_with(job, retries)
    job.perform_later(sender, message_sid, retries: retries)
  end

  private

  attr_accessor :sender, :message_sid
end
