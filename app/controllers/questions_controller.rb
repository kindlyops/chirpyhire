class QuestionsController < ApplicationController
  def new
    @question = authorize(new_question)
  end

  def edit
    @question = authorize(Question.find(params[:id]))
  end

  private

  def new_question
    survey.questions.build(new_question_params)
  end

  def new_question_params
    { priority: survey.questions.active.order(:priority).last.priority + 1 }
  end

  def survey
    current_organization.survey
  end
end
