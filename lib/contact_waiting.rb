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
      sms_notify(account)
      NotificationMailer.contact_waiting(account, conversation).deliver_later
    end
  end

  delegate :inbox, to: :conversation
  delegate :team, to: :inbox
  delegate :accounts, to: :team

  def sms_notify(account)
    return if account.phone_number.blank?

    organization.message(
      recipient: account.person,
      phone_number: organization.phone_numbers.order(:id).first,
      body: contact_waiting_sms(account, conversation)
    )
  end

  def contact_waiting_sms(account, conversation)
    url = inbox_conversation_url(conversation.inbox, conversation)
    <<~body
      Hi #{account.first_name},

      A caregiver is waiting for your reply. Move quick!

      Chat with Caregiver: #{url}
    body
  end

  def read_or_more_recent_unread_receipts?
    read_receipt.read? || more_recent_unread_receipts?
  end

  def more_recent_unread_receipts?
    conversation.read_receipts.unread.after(read_receipt).exists?
  end
end
