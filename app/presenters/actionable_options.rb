class ActionableOptions
  ACTIONS = {
    "Notice" => {
      icon_class: "fa-info",
      title: "Notify candidate",
      subtitle: "Gives the candidate helpful information."
    },
    "Question" => {
      icon_class: "fa-question",
      title: "Ask a question",
      subtitle: "Asks candidate a screening question via text message."
    }
  }

  def actionables
    if action.actionable_type == "Notice"
      organization.notices
    elsif action.actionable_type == "Question"
      organization.questions
    else
      []
    end
  end

  def [](actionable_type)
    OpenStruct.new(ACTIONS[actionable_type])
  end

  def initialize(action)
    @action = action
  end

  def each(&block)
    ACTIONS.map {|actionable_type, hash| hash[:actionable_type] = actionable_type; OpenStruct.new(hash) }.each(&block)
  end

  private

  attr_reader :action

  def organization
    @organization ||= action.organization
  end
end
