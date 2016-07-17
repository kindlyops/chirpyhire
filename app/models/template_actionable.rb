class TemplateActionable < Actionable
  has_one :template, foreign_key: :actionable_id
  delegate :perform, to: :template
end
