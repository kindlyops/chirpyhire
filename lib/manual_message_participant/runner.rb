class ManualMessageParticipant::Runner
  def self.call(participant)
    new(participant).call
  end

  def initialize(participant)
    @participant = participant
  end

  attr_reader :participant

  def call
    return if participant.message.present?

    participant.update(message: message) if message.present?
  end

  def message
    @message ||= begin
      return if manual_message.body.blank?

      create_message.tap(&method(:create_conversation_part))
    end
  end

  def create_message
    organization.message(
      sender: sender,
      recipient: conversation.contact.person,
      phone_number: conversation.phone_number,
      body: manual_message.body
    )
  end

  def create_conversation_part(message)
    conversation.parts.create(
      message: message,
      happened_at: message.external_created_at
    ).tap(&:touch_conversation)
  end

  def sender
    account.person
  end

  def conversation
    @conversation ||= begin
      contact.existing_open_conversation || new_open_conversation
    end
  end

  def new_open_conversation
    IceBreaker.call(contact, phone_number)
  end

  def phone_number
    organization.phone_numbers.first
  end

  delegate :contact, :manual_message, to: :participant
  delegate :account, :organization, to: :manual_message
end
