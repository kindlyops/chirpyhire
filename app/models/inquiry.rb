class Inquiry < ApplicationRecord
  include Messageable
  belongs_to :persona_feature
  has_one :answer
  delegate :format, to: :persona_feature

  scope :unanswered, -> { includes(:answer).where(answers: { inquiry_id: nil }) }

  def question_name
    persona_feature.name
  end

  def unanswered?
    answer.blank?
  end
end

