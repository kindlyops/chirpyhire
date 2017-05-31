class ContactWaiting
  def self.call(inbox_conversation, read_receipt)
    new(inbox_conversation, read_receipt).call
  end

  def initialize(inbox_conversation, read_receipt)
    @inbox_conversation = inbox_conversation
    @read_receipt = read_receipt
  end

  attr_reader :inbox_conversation, :read_receipt

  def call
    return if read_or_more_recent_unread_receipts?

    NotificationMailer.contact_waiting(inbox_conversation).deliver_later
  end

  def read_or_more_recent_unread_receipts?
    read_receipt.read? || more_recent_unread_receipts?
  end

  def more_recent_unread_receipts?
    inbox_conversation.read_receipts.unread.after(read_receipt).exists?
  end
end
