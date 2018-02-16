class Reminder::Alert
  def self.call(reminder)
    new(reminder).call
  end

  def initialize(reminder)
    @reminder = reminder
  end

  def call
    organization.message(
      recipient: contact.person,
      phone_number: phone_number,
      body: alert
    )
  end

  attr_reader :reminder

  delegate :contact, to: :reminder
  delegate :organization, to: :contact
  delegate :current_conversation, to: :contact
  delegate :phone_number, to: :current_conversation
end
