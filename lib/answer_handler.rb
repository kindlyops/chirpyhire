# frozen_string_literal: true
class AnswerHandler
  def self.call(sender, inquiry, message)
    new(sender, inquiry, message).call
  end

  def call
    if inquiry.unanswered? && answer.valid?
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

  def update_or_create_candidate_feature
    feature = candidate.candidate_features.find_or_initialize_by(label: label)
    feature.properties = extracted_properties
    feature.save
  end

  def extracted_properties
    property_extractor.extract(message, inquiry)
  end

  delegate :label, to: :inquiry

  def answer
    @answer ||= inquiry.create_answer(message: message)
  end

  attr_reader :inquiry, :sender, :message

  def candidate
    sender.candidate
  end

  def property_extractor
    AnswerFormatter.new(answer, inquiry).format.constantize
  end
end
