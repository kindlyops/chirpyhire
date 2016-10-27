class AnswerHandler
  def self.call(sender, inquiry, message)
    new(sender, inquiry, message).call
  end

  def call
    if inquiry.unanswered? && answer.errors.empty?
      update_or_create_candidate_feature
      AutomatonJob.perform_later(sender, 'answer')
    end
  end

  def initialize(sender, inquiry, message)
    @sender = sender
    @inquiry = inquiry
    @message = message
  end

  private

  attr_reader :inquiry, :sender, :message
  delegate :label, to: :inquiry

  def update_or_create_candidate_feature
    feature = candidate.candidate_features.find_or_initialize_by(label: label)
    feature.properties = extract_properties
    feature.save
  end

  delegate :label, to: :inquiry

  def answer
    @answer ||= inquiry.create_answer(message: message)
  end

  def candidate
    sender.candidate
  end

  def extract_properties
    inquiry.question_type.constantize.extract(message, inquiry)
  end
end
