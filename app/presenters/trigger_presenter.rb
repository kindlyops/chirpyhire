class TriggerPresenter
  OBSERVABLES = {
    "Candidate" => {
      "subscribe" => {
        "title" => "Subscribes",
        "subtitle" => ->(trigger) {},
        "class" => "fa-hand-paper-o"
      }
    },
    "Question" => {
      "answer" => {
        "title" => "Answers Question",
        "subtitle" => ->(trigger) { trigger.observable.template_name },
        "class" => "fa-reply"
      }
    }
  }

  def initialize(trigger)
    @trigger = trigger
  end

  def description_class
    "#{observable_template['class']}"
  end

  def status_class
    "fa-circle #{status}"
  end

  def title
    observable_template["title"]
  end

  def subtitle
    observable_template["subtitle"].call(trigger)
  end

  def actions
    @actions ||= trigger.actions.map { |action| ActionPresenter.new(action) }
  end

  private

  attr_reader :trigger

  def observable_template
    @observable_template ||= OBSERVABLES[observable_type][event]
  end

  def method_missing(method, *args, &block)
    trigger.send(method, *args, &block)
  end
end
