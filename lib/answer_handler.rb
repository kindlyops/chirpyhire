class AnswerHandler
  def self.call(sender, inquiry, message)
    new(sender, inquiry, message).call
  end

  def call
    handle_answer if inquiry.unanswered?
  end

  def initialize(sender, inquiry, message)
    @sender = sender
    @inquiry = inquiry
    @message = message
  end

  private

  attr_reader :inquiry, :sender, :message
  delegate :label, to: :inquiry

  def handle_answer
    if well_formed_answer?
      update_or_create_candidate_feature
      AutomatonJob.perform_later(sender, 'answer')
    else
      NotUnderstoodHandler.notify(sender, inquiry)
    end
  end

  def update_or_create_candidate_feature
    feature = candidate.candidate_features.find_or_initialize_by(label: label)
    feature.properties = extract_properties
    feature.save
  end

  def answer
    @answer ||= inquiry.create_answer(message: message)
  end

  def well_formed_answer?
    answer.errors.empty?
  end

  def candidate
    sender.candidate
  end

  def extract_properties
    inquiry.question_type.constantize.extract(message, inquiry)
  end
end
