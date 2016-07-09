class UnknownChirpHandler
  def self.call(sender, message_sid)
    new(sender, message_sid).call
  end

  def initialize(sender, message_sid)
    @sender = sender
    @message_sid = message_sid
  end

  def call
    chirp = sender.chirps.create(message: message)
    chirp.update(message_id: message.id)
    chirp
  end

  private

  attr_reader :message_sid, :sender

  def organization
    @organization ||= sender.organization
  end

  def external_message
    @external_message ||= organization.get_message(message_sid)
  end

  def message
    @message ||= MessageHandler.call(sender, external_message)
  end
end
