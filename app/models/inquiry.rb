class Inquiry < ApplicationRecord
  include Messageable
  belongs_to :question
  has_one :answer
  delegate :type, to: :question, prefix: true
  delegate :label, to: :question

  scope :unanswered, -> { includes(:answer).where(answers: { inquiry_id: nil }) }

  def question_name
    question.label
  end

  def unanswered?
    answer.blank?
  end
end

