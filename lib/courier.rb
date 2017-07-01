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
    # 1. Handle chatting into a bot
    #   - Can only be in one bot campaign at a time per phone number.
    #   - If already in a bot campaign send the message through as a regular message.
    #   - If not, trigger the bot campaign to start.
    # 2. Otherwise log a regular message
  end

  def triggered_bot
    bots.find_by(keyword: message.body)
  end

  def rule
    organization.assignment_rules.find_by(phone_number: message.to)
  end

  def team; end

  delegate :organization, to: :contact
  delegate :bots, to: :organization
  delegate :inbox, to: :rule
end
