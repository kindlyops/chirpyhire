class UnknownMessageHandler
  def self.call(sender, message_sid)
    new(sender, message_sid).call
  end

  def initialize(sender, message_sid)
    @sender = sender
    @message_sid = message_sid
  end

  def call
    MessageHandler.call(sender, message_sid)
    sender.update(has_unread_messages: true)
  end

  private

  attr_reader :message_sid, :sender
end
