class MessageHandler
  DEFAULT_RETRIES = 3
  def initialize(sender, message_sid, retries: DEFAULT_RETRIES)
    @sender = sender
    @message_sid = message_sid
    @retries = retries
  end

  def call
    existing_message = sender.messages.find_by(sid: message_sid)
    return existing_message if existing_message.present? else handle_message
  end

  private

  def handle_message
    external_message.media.each do |media_instance|
      message.media_instances.new(
        content_type: media_instance.content_type,
        sid: media_instance.sid,
        uri: media_instance.uri
      )
    end

    message.save
    Threader.new(message).call
    message

  rescue Twilio::REST::RequestError => e
    retries_remaining = @retries - 1
    Rollbar.log(e, "Twilio message not found", { organization_id: @sender.organization_id, retries_remaining: retries_remaining })
    if retries_remaining > 0
      MessageHandlerJob.set(wait: 30.seconds).perform_later(@sender, @message_sid, retries_remaining)
    else
      raise
    end
  end

  def external_message
    organization.get_message(message_sid)
  end

  delegate :organization, to: :sender

  attr_reader :sender, :message_sid

  def message
    @message ||= Message.new(
      sid: external_message.sid,
      body: external_message.body,
      direction: external_message.direction,
      sent_at: external_message.date_sent,
      external_created_at: external_message.date_created,
      user: sender
    )
  end
end
