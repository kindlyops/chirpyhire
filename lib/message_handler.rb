class MessageHandler

  def self.call(sender, external_message)
    new(sender, external_message).call
  end

  def call
    external_message.media.each do |media_instance|
      message.media_instances.create(
        content_type: media_instance.content_type,
        sid: media_instance.sid,
        uri: media_instance.uri
      )
    end

    message
  end

  def initialize(sender, external_message)
    @sender = sender
    @external_message = external_message
  end

  private

  attr_reader :sender, :external_message

  def message
    @message ||= sender.messages.create(
      sid: external_message.sid,
      body: external_message.body,
      direction: external_message.direction
    )
  end
end
