class Courier
  def self.call(contact, message_sid)
    new(contact, message_sid).call
  end

  def initialize(contact, message_sid)
    @contact = contact
    @message_sid = message_sid
  end

  attr_reader :contact, :message_sid

  def call
    # 1. Handle chatting into a bot
    #   - Can only be in one bot campaign at a time per phone number.
    #   - If already in a bot campaign send the message through as a regular message.
    #   - If not, trigger the bot campaign to start.
    # 2. Otherwise log a regular message
  end
end
