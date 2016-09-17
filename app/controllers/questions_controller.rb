# frozen_string_literal: true
class QuestionsController < ApplicationController
  decorates_assigned :question

  def new
    @question = authorize(built_question)
  end

  def edit
    @question = authorize(Question.find(params[:id]))
  end

  def create
    @question = authorize(new_question)
    if @question.save
      redirect_to survey_url, notice: 'Nice! Question saved.'
    else
      render :new
    end
  end

  def update
    @question = authorized_question

    if @question.update(permitted_question_attributes)
      redirect_to survey_url, notice: 'Nice! Question saved.'
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
    { priority: new_priority }
  end

  def new_priority
    highest_priority_question = survey.questions.active.order(:priority).last
    return 1 unless highest_priority_question.present?
    highest_priority_question.priority + 1
  end

  def survey
    current_organization.survey
  end
end
