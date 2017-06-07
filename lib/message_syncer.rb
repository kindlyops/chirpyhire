class MessageSyncer
  def initialize(contact, message_sid, receipt: false)
    @contact      = contact
    @message_sid  = message_sid
    @receipt      = receipt
  end

  def self.call(contact, message_sid, receipt: false)
    new(contact, message_sid, receipt: receipt).call
  end

  def call
    existing_message = person.sent_messages.find_by(sid: message_sid)
    return existing_message if existing_message.present?
    message = sync_message
    contact.update(last_reply_at: message.created_at)
    create_read_receipts(message) if receipt_requested?
    Broadcaster::Message.new(message).broadcast
    message
  end

  private

  def external_message
    @external_message ||= organization.get_message(message_sid)
  end

  attr_reader :contact, :message_sid, :receipt
  delegate :person, :organization, :open_conversation, to: :contact

  def sync_message
    open_conversation.messages.create!(message_params).tap(&:touch_conversation)
  end

  def message_params
    {
      sid: external_message.sid,
      body: external_message.body,
      direction: external_message.direction,
      sent_at: external_message.date_sent,
      external_created_at: external_message.date_created
    }.merge(sender: person)
  end

  def create_read_receipts(message)
    ReadReceiptsCreator.call(message, contact) if receipt_requested?
  end

  def receipt_requested?
    receipt.present?
  end
end
