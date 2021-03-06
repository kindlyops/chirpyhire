class Reminder::Alert
  def self.call(reminder)
    new(reminder).call
  end

  def initialize(reminder)
    @reminder = reminder
  end

  def call
    current_conversation.parts.create(
      message: message,
      happened_at: message.external_created_at
    ).tap(&:touch_conversation)
  end

  def message
    # setting this raven user context should provide some assistance with
    # tracking down users that have invalid phone numbers and we are
    # crashing while trying to send a reminder.
    Raven.breadcrumbs.record do |crumb|
      crumb.data = { contact_id: contact.id, contact_name: contact.name, number: phone_number.phone_number }
      crumb.message = "Additional debugging data, phone number is #{phone_number.phone_number.length} chars long"
    end

    @message ||= begin
      organization.message(
        recipient: contact.person,
        phone_number: phone_number,
        sender: bot.person,
        body: alert
      )
    end
  end

  def bot
    contact_bot || organization.recent_bot
  end

  def contact_bot
    contact.active_campaign_contacts.map(&:campaign).map(&:bot).first
  end

  attr_reader :reminder

  delegate :contact, to: :reminder
  delegate :organization, to: :contact
  delegate :current_conversation, to: :contact
  delegate :phone_number, to: :current_conversation
end
