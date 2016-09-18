class SurveyDecorator < Draper::Decorator
  delegate_all

  def questions
    object.questions.order(:status, :priority)
  end
end
