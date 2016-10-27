class Survey < ApplicationRecord
  belongs_to :organization
  belongs_to :actionable,
             class_name: 'SurveyActionable',
             foreign_key: :actionable_id,
             inverse_of: :survey

  belongs_to :welcome, class_name: 'Template', foreign_key: :welcome_id
  belongs_to :thank_you, class_name: 'Template', foreign_key: :thank_you_id
  belongs_to :bad_fit, class_name: 'Template', foreign_key: :bad_fit_id

  has_many :questions
  accepts_nested_attributes_for :questions,
                                reject_if: :all_blank, allow_destroy: false

  validate :unique_priorities, on: :update

  def perform(user)
    CandidateAdvancer.call(user)
  end

  def address_question?
    questions.where(type: AddressQuestion.name).present?
  end

  def next_unasked_question_for(user)
    ids = user.inquiries.pluck(:question_id)
    questions
      .where.not(id: ids)
      .where(status: Question.statuses[:active])
      .order(:priority).first
  end

  private

  def unique_priorities
    active_questions = questions.select(&:active?)
    unique_priorities = active_questions.map(&:priority).uniq
    unless unique_priorities.count == active_questions.count
      errors[:question_priorities] << 'Each question priority must be unique.'
    end
  end
end
