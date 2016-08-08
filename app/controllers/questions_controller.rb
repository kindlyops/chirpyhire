class QuestionsController < ApplicationController
  def new
    @question = authorize(built_question)
  end

  def edit
    @question = authorize(Question.find(params[:id]))
  end

  def create
    @question = authorize(new_question)
    if @question.save
      redirect_to survey_url, notice: "Nice! Question saved."
    else
      render :new
    end
  end

  def update
    if authorized_question.update(permitted_question_attributes)
      redirect_to survey_url, notice: "Nice! Question saved."
    else
      render :edit
    end
  end

  private

  def new_question
    survey.questions.build(permitted_question_attributes)
  end

  def built_question
    survey.questions.build(built_question_params)
  end

  def built_question_params
    { priority: survey.questions.active.order(:priority).last.priority + 1 }
  end

  def survey
    current_organization.survey
  end
end
