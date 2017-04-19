class MessageSyncerJob < MessageRetryJob
  def perform(contact, message_sid, receipt: false,
              retries: MessageRetryJob::DEFAULT_RETRIES)
    @contact = contact
    @message_sid = message_sid
    @receipt = receipt
    @retries_remaining = retries

    MessageSyncer.new(contact, message_sid, receipt: receipt).call
  end

  def retry_with(job, retries)
    job.perform_later(
      contact,
      message_sid,
      receipt: receipt,
      retries: retries
    )
  end

  private

  attr_accessor :contact, :message_sid, :receipt
end
