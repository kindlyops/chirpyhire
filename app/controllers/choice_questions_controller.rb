class ChoiceQuestionsController < QuestionsController
  def new
    @question = authorize(new_question)
  end

  def update
    if authorized_question.update(permitted_attributes(ChoiceQuestion).merge(updated_at: Time.current))
      redirect_to survey_url, notice: "Nice! Question saved."
    else
      render :edit
    end
  end

  private

  def authorized_question
    authorize ChoiceQuestion.find(params[:id])
  end

  def new_question_params
    super.merge(type: "ChoiceQuestion", choice_question_options_attributes: [
      {letter: "a"}, {letter: "b"}
    ])
  end
end
