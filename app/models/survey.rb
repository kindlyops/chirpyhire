class Survey < ApplicationRecord
  belongs_to :organization
  belongs_to :template
  belongs_to :actionable, class_name: "SurveyActionable", foreign_key: :actionable_id, inverse_of: :survey
  belongs_to :welcome, class_name: "Template", foreign_key: :welcome_id, inverse_of: :survey
  belongs_to :thank_you, class_name: "Template", foreign_key: :thank_you_id, inverse_of: :survey
  belongs_to :bad_fit, class_name: "Template", foreign_key: :bad_fit_id, inverse_of: :survey

  has_many :questions
  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: false

  validate do |survey|
    SurveyValidator.new(survey).validate
  end

  def perform(user)
    ProfileAdvancer.call(user)
  end

  SurveyValidator = Struct.new(:survey) do
    def validate
      active_questions = survey.questions.select { |q| q.active? }
      unique_priorities = active_questions.map(&:priority).uniq
      unless unique_priorities.count == active_questions.count
        survey.errors[:question_priorities] << "Each question priority must be unique."
      end
    end
  end
end
