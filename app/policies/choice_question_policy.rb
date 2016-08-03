class ChoiceQuestionPolicy < QuestionPolicy
  def permitted_attributes
    super.push(choice_question_options_attributes: [:id, :_destroy, :letter, :text])
  end
end
