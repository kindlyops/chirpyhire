class RuleDecorator < Draper::Decorator
  delegate_all

  delegate :title, :subtitle, :icon_class, :label, to: :action, prefix: true
  delegate :title, :subtitle, :icon_class, :event, to: :trigger, prefix: true

  def action
    @action ||= object.action.decorate
  end

  def state_class
    "fa-circle #{state.downcase}"
  end

  def state
    enabled? ? "Enabled" : "Disabled"
  end

  def trigger
    @trigger ||= "#{object.trigger.humanize}Presenter".constantize.new
  end
end
