class MessageSyncerJob < MessageRetryJob
  def perform(sender, organization, message_sid,
              retries: MessageRetryJob::DEFAULT_RETRIES)
    @sender = sender
    @organization = organization
    @message_sid = message_sid
    @retries_remaining = retries

    MessageSyncer.new(sender, organization, message_sid).call
  end

  def retry_with(job, retries)
    job.perform_later(sender, organization, message_sid, retries: retries)
  end

  private

  attr_accessor :sender, :message_sid, :organization
end
