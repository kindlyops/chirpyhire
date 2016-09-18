class Inquiry < ApplicationRecord
  include Messageable
  belongs_to :question
  has_one :answer
  delegate :label, to: :question
  delegate :type, to: :question, prefix: true

  def self.unanswered
    includes(:answer).where(answers: { inquiry_id: nil })
  end

  def question_name
    question.label
  end

  def unanswered?
    answer.blank?
  end

  def of_address?
    question_type == 'AddressQuestion'
  end

  def of?(format)
    question_type == format
  end
end
