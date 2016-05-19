class TriggerDecorator < Draper::Decorator
  delegate_all
  decorates_association :actions
  delegate :title, :subtitle, :icon_class, to: :observable_template
  delegate :observables, to: :observable_options

  def observable_options
    ObservableOptions.new(object)
  end

  def actionable_options
    ActionableOptions.new(object)
  end

  def state_class
    "fa-circle #{state}"
  end

  def template_name
    if observable.present?
      observable.template_name
    end
  end

  def state
    enabled? ? "enabled" : "disabled"
  end

  private

  def observable_template
    @observable_template ||= observable_options[event.to_sym]
  end
end
