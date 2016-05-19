class RuleDecorator < Draper::Decorator
  delegate_all

  def actionable
    @actionable ||= "#{object.actionable.class}Decorator".constantize.new(object.actionable)
  end

  def trigger
    @trigger ||= "#{object.trigger.observable_type}#{object.trigger.event.humanize}Decorator".constantize.new(object.trigger)
  end

  delegate :title, :subtitle, :icon_class, :template_name, :options, to: :actionable, prefix: true
  delegate :title, :subtitle, :icon_class, :template_name, :options, to: :trigger, prefix: true

  def state_class
    "fa-circle #{state.downcase}"
  end

  def state
    enabled? ? "Enabled" : "Disabled"
  end
end
