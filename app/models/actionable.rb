class Actionable < ApplicationRecord
  TYPES = %w(TemplateActionable CandidatePersonaActionable)
  validates_inclusion_of :type, in: TYPES
end
