class ObservableOptions
  OBSERVABLES = {
    subscribe: {
      model: "Candidate",
      title: "Subscribes",
      icon_class: "fa-hand-paper-o",
      subtitle: "Candidate opts-in to receiving communications via text message."
    },
    answer: {
      model: "Question",
      title: "Answers a question",
      icon_class: "fa-reply",
      subtitle: "Candidate answers a screening question via text message."
    }
  }

  def initialize(trigger)
    @trigger = trigger
  end

  def observables
    return [] if trigger.observable_type == "Candidate"
    organization.questions
  end

  def [](event)
    OpenStruct.new(OBSERVABLES[event])
  end

  def each(&block)
    OBSERVABLES.map {|event, hash| hash[:event] = event; OpenStruct.new(hash) }.each(&block)
  end

  private

  attr_reader :trigger

  def organization
    @organization ||= trigger.organization
  end
end
