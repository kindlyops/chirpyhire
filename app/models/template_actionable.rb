class TemplateActionable < Actionable
  has_one :template
  delegate :perform, to: :template
end
