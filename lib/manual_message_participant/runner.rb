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

      organization.message(
        sender: sender,
        conversation: conversation,
        body: manual_message.body
      )
    end
  end

  def sender
    account.person
  end

  def conversation
    contact.existing_open_conversation || IceBreaker.call(contact, phone_number)
  end

  def phone_number
    organization.phone_numbers.first
  end

  delegate :contact, :manual_message, to: :participant
  delegate :account, :organization, to: :manual_message
end
