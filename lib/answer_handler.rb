class AnswerHandler

  def self.call(sender, inquiry, message)
    new(sender, inquiry, message).call
  end

  def call
    if inquiry.unanswered? && answer.valid?
      AutomatonJob.perform_later(sender, "answer")
      update_or_create_candidate_feature
    end
  end

  def initialize(sender, inquiry, message)
    @sender = sender
    @inquiry = inquiry
    @message = message
  end

  private

  def update_or_create_candidate_feature
    feature = candidate.candidate_features.find_or_initialize_by(category: category)
    feature.properties = extracted_properties
    feature.save
  end

  def extracted_properties
    property_extractor.extract(message, persona_feature)
  end

  def category
    persona_feature.category
  end

  def persona_feature
    @persona_feature ||= inquiry.persona_feature
  end

  def answer
    @answer ||= inquiry.create_answer(message: message)
  end

  attr_reader :inquiry, :sender, :message

  def candidate
    sender.candidate
  end

  def property_extractor
    AnswerFormatter.new(answer, persona_feature).format.titlecase.constantize
  end
end
