class SubscribeDecorator < Draper::Decorator
  delegate_all

  def template_name
    ""
  end

  def title
    "Subscribes"
  end

  def subtitle
    "Candidate opts-in to receiving communications via text message."
  end

  def icon_class
    "fa-hand-paper-o"
  end

  def options
    []
  end
end
