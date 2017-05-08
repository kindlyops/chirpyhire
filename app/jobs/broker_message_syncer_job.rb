class BrokerMessageSyncerJob < MessageRetryJob
  def perform(broker_contact, message_sid,
              retries: MessageRetryJob::DEFAULT_RETRIES)
    @broker_contact = broker_contact
    @message_sid = message_sid
    @retries_remaining = retries

    BrokerMessageSyncer.new(broker_contact, message_sid).call
  end

  def retry_with(job, retries)
    job.perform_later(
      broker_contact,
      message_sid,
      retries: retries
    )
  end

  private

  attr_accessor :broker_contact, :message_sid
end
