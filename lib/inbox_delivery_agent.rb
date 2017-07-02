class InboxDeliveryAgent
  def self.call(inbox, message)
    new(inbox, message).call
  end

  def initialize(inbox, message)
    @inbox = inbox
    @message = message
  end

  attr_reader :message, :inbox

  def call; end
end

# 1. Handle chatting into a bot
#   - Can only be in one bot campaign at a time per phone number.
#   - If already in a bot campaign send the message through as a regular message.
#   - If not, trigger the bot campaign to start.
# 2. Otherwise log a regular message
# Using assignment rules route message to appropriate Inbox
# Once at the Inbox see if there are any bots to handle the message or log a regular message.
