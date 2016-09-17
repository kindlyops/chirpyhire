# frozen_string_literal: true
class TemplateActionable < Actionable
  has_one :template, foreign_key: :actionable_id, inverse_of: :actionable
  delegate :perform, to: :template
end
