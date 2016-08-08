class QuestionsController < ApplicationController
  def new
    @question = authorize(new_question)
  end

  def edit
    @question = authorize(Question.find(params[:id]))
  end

  private

  def new_question
    survey.questions.build(priority: new_priority)
  end

  def new_priority
    survey.questions.active.order(:priority).last.priority + 1
  end

  def survey
    current_organization.survey
  end
end
