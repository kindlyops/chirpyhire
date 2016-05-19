class AnswerDecorator < Draper::Decorator
  delegate_all

  def title
    "Answers a question"
  end

  def subtitle
    "Candidate answers a screening question via text message."
  end

  def icon_class
    "fa-reply"
  end
end
