class ChoiceQuestionsController < QuestionsController

  private

  def permitted_question_attributes
    permitted_attributes(ChoiceQuestion).merge(updated_at: Time.current)
  end

  def authorized_question
    authorize ChoiceQuestion.find(params[:id])
  end

  def built_question_params
    super.merge(type: "ChoiceQuestion", choice_question_options_attributes: [
      {letter: "a"}, {letter: "b"}
    ])
  end
end
