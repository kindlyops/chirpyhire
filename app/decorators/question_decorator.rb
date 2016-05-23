class QuestionDecorator < Draper::Decorator
  delegate_all

  def label
    template_name
  end

  def title
    "Ask a question"
  end

  def subtitle
    "Asks candidate a screening question via text message."
  end

  def icon_class
    "fa-question"
  end

  def options
    organization.questions
  end

  def category
    object.class.to_s.humanize
  end
end
