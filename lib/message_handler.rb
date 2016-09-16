class MessageHandler

  def initialize(sender, message_sid)
    @sender = sender
    @message_sid = message_sid
  end

  def call
    existing_message = sender.messages.find_by(sid: message_sid)
    return existing_message if existing_message.present?

    begin
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
      Rollbar.log(e, "Twilio message not found", { organization_id: @sender.organization_id })
      MessageHandlerJob.perform_in(30.seconds, @sender, @message_sid)
    end
  end

  private

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
