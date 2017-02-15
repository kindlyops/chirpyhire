class Inquiry < ApplicationRecord
  include Messageable
  include PublicActivity::Model
  tracked(
    only: [:update],
    on: {
      update: ->(model, _) { model.changes.include?('not_understood_count') }
    },
    properties: lambda do |_, model|
      {
        not_understood_count: model.not_understood_count,
        question_type: model.question.type
      }
    end,
    owner: proc { |_, model| model.organization }
  )
  belongs_to :question
  has_one :answer
  has_many :activities, as: :trackable
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

  def asks_question_of?(question_class)
    question_type == question_class.name
  end
end
