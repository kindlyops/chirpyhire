class Actionable < ApplicationRecord
  TYPES = %w(TemplateActionable CandidatePersonaActionable SurveyActionable)
  validates_inclusion_of :type, in: TYPES
end
