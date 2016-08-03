class ChoiceQuestionPolicy < QuestionPolicy
  def permitted_attributes
    [choice_question_options: [:id, :_destroy, :letter, :text]]
  end
end
