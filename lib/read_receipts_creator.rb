class ReadReceiptsCreator
  def initialize(message, contact)
    @message = message
    @contact = contact
  end

  def self.call(message, contact)
    new(message, contact).call
  end

  def self.wait_until
    90.seconds.from_now
  end

  def wait_until
    self.class.wait_until
  end

  def call
    receipt = conversation.read_receipts.find_by(message: message)
    return if receipt.present?

    create_read_receipt
  end

  def create_read_receipt
    receipt = conversation.read_receipts.create!(message: message)
    contact_waiting_job.perform_later(conversation, receipt)
    Broadcaster::Conversation.broadcast(conversation)
  end

  def contact_waiting_job
    ContactWaitingJob.set(wait_until: wait_until)
  end

  attr_reader :message, :contact
  delegate :conversation, to: :message
end
