class SurveyActionable < Actionable
  has_one :survey, foreign_key: :actionable_id, inverse_of: :actionable
  delegate :perform, to: :survey
end
