class AnswerHandler

  def self.call(sender, inquiry, message_sid)
    new(sender, inquiry, message_sid).call
  end

  def call
    create_media_instances
    if answer.valid?
      AutomatonJob.perform_later(sender, "answer")
      answer
    else
      create_message_task
    end
  end

  def initialize(sender, inquiry, message_sid)
    @sender = sender
    @inquiry = inquiry
    @message_sid = message_sid
  end

  private

  def answer
    @answer ||= inquiry.create_answer(message: message)
  end

  attr_reader :inquiry, :sender, :message_sid

  def organization
    @organization ||= sender.organization
  end

  def external_message
    @external_message ||= organization.get_message(message_sid)
  end

  def message
    @message ||= sender.messages.create(
      sid: external_message.sid,
      body: external_message.body,
      direction: external_message.direction
    )
  end

  def create_media_instances
    external_message.media.each do |media_instance|
      message.media_instances.create(
        content_type: media_instance.content_type,
        sid: media_instance.sid,
        uri: media_instance.uri
      )
    end
  end

  def create_message_task
    sender.tasks.create(taskable: message) unless sender.outstanding_task_for?(message)
  end
end
