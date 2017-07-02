class Courier
  def self.call(contact, message)
    new(contact, message).call
  end

  def initialize(contact, message)
    @contact = contact
    @message = message
  end

  attr_reader :contact, :message

  def call
    InboxCourier.call(inbox, contact, message)
  end

  def assignment_rule
    organization.assignment_rules.find_by(phone_number: phone_number)
  end

  def phone_number
    organization.phone_numbers.find_by(phone_number: message.to)
  end

  delegate :organization, to: :contact
  delegate :inbox, to: :assignment_rule
end

# 1. Handle chatting into a bot
#   - Can only be in one bot campaign at a time per phone number.
#   - If already in a bot campaign send the message through as a regular message.
#   - If not, trigger the bot campaign to start.
# 2. Otherwise log a regular message
# Using assignment rules route message to appropriate Inbox
# Once at the Inbox see if there are any bots to handle the message or log a regular message.
