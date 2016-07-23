class MessageHandler

  def self.call(sender, external_message)
    new(sender, external_message).call
  end

  def call
    external_message.media.each do |media_instance|
      message.media_instances.new(
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
    @message ||= Message.new(
      sid: external_message.sid,
      body: external_message.body,
      direction: external_message.direction,
      sent_at: external_message.date_sent,
      external_created_at: external_message.date_created,
      user: sender,
      parent: sender.messages.by_recency.first
    )
  end
end
