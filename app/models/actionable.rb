class Actionable < ApplicationRecord
  TYPES = %w(TemplateActionable SurveyActionable).freeze
  validates :type, inclusion: { in: TYPES }
end
