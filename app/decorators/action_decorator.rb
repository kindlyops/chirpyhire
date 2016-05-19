class ActionDecorator < Draper::Decorator
  delegate_all
  delegate :title, :subtitle, :icon_class, to: :actionable_template
  delegate :actionables, to: :actionable_options

  def description
    actionable.template_name
  end

  private

  def actionable_template
    @actionable_template ||= actionable_options[actionable_type]
  end

  def actionable_options
    @actionable_options ||= ActionableOptions.new(object)
  end
end
