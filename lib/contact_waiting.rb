class ContactWaiting
  def self.call(conversation, read_receipt)
    new(conversation, read_receipt).call
  end

  def initialize(conversation, read_receipt)
    @conversation = conversation
    @read_receipt = read_receipt
  end

  attr_reader :conversation, :read_receipt

  def call
    return if read_receipt.read?

    NotificationMailer.contact_waiting(conversation).deliver_later
  end
end
