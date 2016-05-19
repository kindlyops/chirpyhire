class RuleDecorator < Draper::Decorator
  delegate_all

  def action
    @action ||= "#{object.action.class}Decorator".constantize.new(object.action)
  end

  def trigger
    @trigger ||= "#{object.trigger_type}#{event.humanize}Decorator".constantize.new(object.trigger)
  end

  delegate :title, :subtitle, :icon_class, to: :action, prefix: true
  delegate :title, :subtitle, :icon_class, :template_name, to: :trigger, prefix: true

  def state_class
    "fa-circle #{state.downcase}"
  end

  def state
    enabled? ? "Enabled" : "Disabled"
  end
end
