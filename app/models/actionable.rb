class Actionable < ApplicationRecord
  TYPES = %w(TemplateActionable SurveyActionable)
  validates_inclusion_of :type, in: TYPES
end
