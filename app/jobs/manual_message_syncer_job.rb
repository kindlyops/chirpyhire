class ManualMessageSyncerJob < MessageSyncerJob
  def perform(sender, organization, message_sid,
              retries: MessageRetryJob::DEFAULT_RETRIES)
    @sender = sender
    @organization = organization
    @message_sid = message_sid
    @retries_remaining = retries

    MessageSyncer.new(sender, organization, message_sid).call do |message|
      ReadReceiptsCreator.new(message, organization).call
    end
  end
end
