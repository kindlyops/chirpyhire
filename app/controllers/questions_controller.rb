class QuestionsController < ApplicationController
  decorates_assigned :question
  helper QuestionHelper
  def new
    @question = authorize(built_question)
  end

  def edit
    @question = authorize(Question.find(params[:id]))
  end

  def show
    redirect_to edit_question_path(authorize(Question.find(params[:id])))
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

  def new_priority
    highest_priority_question = survey.questions.active.order(:priority).last
    return 1 unless highest_priority_question.present?
    highest_priority_question.priority + 1
  end

  def built_question_params
    {
      priority: new_priority,
      type: question_type
    }
  end

  def authorized_question
    authorize question_type_class.find(params[:id])
  end

  def permitted_question_attributes
    permitted_attributes(question_type_class)
  end

  def question_type
    controller_name = self.class.name
    @question_type ||= controller_name.chomp('sController')
  end

  def question_type_class
    @question_type_class = question_type.constantize
  end

  def survey
    current_organization.survey
  end
end
