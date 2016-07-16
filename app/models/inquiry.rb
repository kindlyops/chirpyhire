class Inquiry < ApplicationRecord
  include Messageable
  belongs_to :candidate_feature

  has_one :answer
  delegate :format, :persona_feature_name, to: :candidate_feature

  scope :unanswered, -> { includes(:answer).where(answers: { inquiry_id: nil }) }

  def question_name
    persona_feature_name
  end

  def unanswered?
    answer.blank?
  end
end
