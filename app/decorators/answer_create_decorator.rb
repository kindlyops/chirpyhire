class AnswerCreateDecorator < Draper::Decorator
  delegate_all

  def subtitle
    "Answer to #{question_name} question"
  end

  def color
    "success"
  end

  def icon_class
    "fa-reply"
  end
end
