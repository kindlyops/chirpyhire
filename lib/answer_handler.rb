class AnswerHandler

  def self.call(sender, inquiry, message_sid)
    new(sender, inquiry, message_sid).call
  end

  def call
    if inquiry.unanswered? && answer.valid?
      AutomatonJob.perform_later(sender, "answer")
      candidate_feature.update(properties: extracted_properties)
      answer
    else
      chirp = sender.chirps.create(message: message)
      chirp.update(message_id: message.id)
      chirp
    end
  end

  def initialize(sender, inquiry, message_sid)
    @sender = sender
    @inquiry = inquiry
    @message_sid = message_sid
  end

  private

  def extracted_properties
    property_extractor.extract(message, candidate_feature.persona_feature)
  end

  def answer
    @answer ||= begin
      answer = inquiry.create_answer(user: sender, message: message)
      answer.update(message_id: message.id)
      answer
    end
  end

  def candidate_feature
    @candidate_feature ||= inquiry.candidate_feature
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
end
