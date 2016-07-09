class UnknownMessageHandler
  def self.call(sender, message_sid)
    new(sender, message_sid).call
  end

  def initialize(sender, message_sid)
    @sender = sender
    @message_sid = message_sid
  end

  def call
    MessageHandler.call(sender, external_message)
  end

  private

  attr_reader :message_sid, :sender

  def organization
    @organization ||= sender.organization
  end

  def external_message
    @external_message ||= organization.get_message(message_sid)
  end
end
