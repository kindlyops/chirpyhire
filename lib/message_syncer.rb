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
    return existing_message if existing_message.present?

    contact.update(last_reply_at: new_message.created_at)
    create_read_receipts if receipt_requested?
    create_reply if manual_message_present?
    broadcast_part
    new_message
  end

  private

  def create_reply
    recent_message.manual_message_participant.update(reply: new_message)
  end

  def manual_message_present?
    recent_message && recent_message.manual_message_participant.present?
  end

  def broadcast_part
    Broadcaster::Part.new(new_message.conversation_part).broadcast
  end

  def existing_message
    @existing_message ||= person.sent_messages.find_by(sid: message_sid)
  end

  def external_message
    @external_message ||= organization.get_message(message_sid)
  end

  attr_reader :contact, :message_sid, :receipt
  delegate :person, :organization, to: :contact
  delegate :recent_part, to: :current_conversation

  def recent_message
    recent_part && recent_part.message
  end

  def new_message
    @new_message ||= begin
      organization
        .messages
        .create!(message_params)
        .tap(&method(:create_conversation_part))
    end
  end

  def create_conversation_part(message)
    current_conversation.parts.create(
      message: message,
      happened_at: message.external_created_at
    ).tap(&:touch_conversation)
  end

  def current_conversation
    @current_conversation ||= IceBreaker.call(contact, phone_number)
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

  def create_read_receipts
    ReadReceiptsCreator.call(new_message, contact)
  end

  def receipt_requested?
    receipt.present?
  end
end
