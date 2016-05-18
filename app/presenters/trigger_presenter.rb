class TriggerPresenter

  delegate :title, :subtitle, :icon_class, to: :observable_template
  delegate :observables, to: :observable_options

  def initialize(trigger)
    @trigger = trigger
  end

  def observable_options
    ObservableOptions.new(trigger)
  end

  def actionable_options
    ActionableOptions.new(trigger)
  end

  def state_class
    "fa-circle #{state}"
  end

  def template_name
    if trigger.observable.present?
      trigger.observable.template_name
    end
  end

  def actions
    @actions ||= trigger.actions.map { |action| ActionPresenter.new(action) }
  end

  private

  attr_reader :trigger

  def observable_template
    @observable_template ||= observable_options[event.to_sym]
  end

  def method_missing(method, *args, &block)
    trigger.send(method, *args, &block)
  end
end
