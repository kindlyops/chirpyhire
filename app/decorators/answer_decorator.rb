class AnswerDecorator < Draper::Decorator
  delegate_all

  def subtitle
    "Answer to #{question_name} question"
  end
end
