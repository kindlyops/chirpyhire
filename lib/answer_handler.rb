class AnswerHandler

  def self.call(sender, inquiry, message_sid)
    new(sender, inquiry, message_sid).call
  end

  def call
    if answer.valid?
      AutomatonJob.perform_later(sender, "answer")
      user_feature.update(properties: extracted_properties)
      answer
    else
      create_chirp_task
    end
  end

  def initialize(sender, inquiry, message_sid)
    @sender = sender
    @inquiry = inquiry
    @message_sid = message_sid
  end

  private

  def extracted_properties
    property_extractor.extract(message)
  end

  def answer
    @answer ||= inquiry.create_answer(user: sender, message: message)
  end

  def user_feature
    @user_feature ||= inquiry.user_feature
  end

  attr_reader :inquiry, :sender, :message_sid

  def organization
    @organization ||= sender.organization
  end

  def external_message
    @external_message ||= organization.get_message(message_sid)
  end

  def message
    @message ||= MessageHandler.call(sender, external_message)
  end

  def property_extractor
    answer.format.titlecase.constantize
  end

  def create_chirp_task
    chirp = sender.chirps.create(message: message)
    sender.tasks.create(taskable: chirp)
  end
end
