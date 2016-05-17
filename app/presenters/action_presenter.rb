class ActionPresenter
  ACTIONABLES = {
    "Notice" => {
      "class" => "fa-info"
    },
    "Question" => {
      "class" => "fa-question"
    }
  }

  def initialize(action)
    @action = action
  end

  def actionable_class
    actionable_template["class"]
  end

  private

  attr_reader :action

  def actionable_template
    @actionable_template ||= ACTIONABLES[actionable_type]
  end

  def method_missing(method, *args, &block)
    action.send(method, *args, &block)
  end
end
