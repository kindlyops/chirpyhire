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
    question_type == AddressQuestion.name
  end

  def of_zipcode?
    question_type == ZipcodeQuestion.name
  end

  def asks_question_of?(question_class)
    question_type == question_class.name
  end
end
