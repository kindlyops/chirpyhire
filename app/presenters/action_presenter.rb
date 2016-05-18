class ActionPresenter

  delegate :title, :subtitle, :icon_class, to: :actionable_template
  delegate :actionables, to: :actionable_options

  def initialize(action)
    @action = action
  end

  private

  attr_reader :action

  def actionable_template
    @actionable_template ||= actionable_options[actionable_type]
  end

  def actionable_options
    @actionable_options ||= ActionableOptions.new(action)
  end

  def method_missing(method, *args, &block)
    action.send(method, *args, &block)
  end
end
