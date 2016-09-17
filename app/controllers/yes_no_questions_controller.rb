# frozen_string_literal: true
class YesNoQuestionsController < QuestionsController
  private

  def permitted_question_attributes
    permitted_attributes(YesNoQuestion)
  end

  def authorized_question
    authorize YesNoQuestion.find(params[:id])
  end

  def built_question_params
    super.merge(type: 'YesNoQuestion')
  end
end
