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
end
