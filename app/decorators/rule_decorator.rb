class RuleDecorator < Draper::Decorator
  delegate_all
  decorates_association :trigger
  decorates_association :action

  delegate :title, :subtitle, :icon_class, :label, to: :action, prefix: true
  delegate :title, :subtitle, :icon_class, :label, to: :trigger, prefix: true

  def state_class
    "fa-circle #{state.downcase}"
  end

  def state
    enabled? ? "Enabled" : "Disabled"
  end
end
