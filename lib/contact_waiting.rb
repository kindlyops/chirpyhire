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
    return if read_or_more_recent_unread_receipts?

    accounts.find_each do |account|
      next if account.contact_waiting.blank?
      NotificationMailer.contact_waiting(account, conversation).deliver_later
    end
  end

  delegate :inbox, to: :conversation
  delegate :team, to: :inbox
  delegate :accounts, to: :team

  def read_or_more_recent_unread_receipts?
    read_receipt.read? || more_recent_unread_receipts?
  end

  def more_recent_unread_receipts?
    conversation.read_receipts.unread.after(read_receipt).exists?
  end
end
