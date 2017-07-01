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
  delegate :person, :organization, to: :contact

  def sync_message
    open_conversation.messages.create!(message_params).tap(&:touch_conversation)
  end

  def open_conversation
    IceBreaker.call(self, phone_number)
  end

  def phone_number
    @phone_number ||= begin
      organization.phone_numbers.find_by(phone_number: external_message.to)
    end
  end

  def param_keys
    %i[sid to from body direction]
  end

  def base_message_params
    param_keys.each_with_object({}) do |key, hash|
      hash[key] = external_message.send(key)
    end
  end

  def message_params
    base_message_params.merge(
      sent_at: external_message.date_sent,
      external_created_at: external_message.date_created,
      sender: person
    )
  end

  def create_read_receipts(message)
    ReadReceiptsCreator.call(message, contact) if receipt_requested?
  end

  def receipt_requested?
    receipt.present?
  end
end
