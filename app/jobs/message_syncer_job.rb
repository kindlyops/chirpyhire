class MessageSyncerJob < MessageRetryJob
  def perform(sender, organization, message_sid, receipt: false,
              retries: MessageRetryJob::DEFAULT_RETRIES)
    @sender = sender
    @organization = organization
    @message_sid = message_sid
    @receipt = receipt
    @retries_remaining = retries

    sync_message
  end

  def retry_with(job, retries)
    job.perform_later(
      sender,
      organization,
      message_sid,
      receipt: receipt,
      retries: retries
    )
  end

  private

  attr_accessor :sender, :message_sid, :organization, :receipt

  def sync_message
    MessageSyncer.new(
      sender,
      organization,
      message_sid,
      receipt: receipt
    ).call
  end
end
