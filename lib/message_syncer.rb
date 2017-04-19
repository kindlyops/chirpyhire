class MessageSyncer
  def initialize(contact, message_sid, receipt: false)
    @contact      = contact
    @message_sid  = message_sid
    @receipt      = receipt
  end

  def call
    existing_message = person.sent_messages.find_by(sid: message_sid)
    return existing_message if existing_message.present?
    message = sync_message
    update_contact(message)
    create_read_receipts(message) if receipt_requested?
    Broadcaster::Message.new(message).broadcast
    Broadcaster::Sidebar.new(organization).broadcast
    message
  end

  private

  def external_message
    organization.get_message(message_sid)
  end

  attr_reader :contact, :message_sid, :receipt
  delegate :person, :organization, to: :contact

  def sync_message
    person.sent_messages.create!(
      sid: external_message.sid,
      body: external_message.body,
      direction: external_message.direction,
      sent_at: external_message.date_sent,
      external_created_at: external_message.date_created,
      organization: organization
    )
  end

  def update_contact(message)
    contact.update(last_reply_at: message.created_at)
    Broadcaster::LastReply.new(contact).broadcast
    Broadcaster::Temperature.new(contact).broadcast
  end

  def create_read_receipts(message)
    ReadReceiptsCreator.call(message, organization) if receipt_requested?
  end

  def receipt_requested?
    receipt.present?
  end
end
