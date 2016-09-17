# frozen_string_literal: true
class SurveyDecorator < Draper::Decorator
  delegate_all

  def questions
    object.questions.order(:status, :priority)
  end
end
