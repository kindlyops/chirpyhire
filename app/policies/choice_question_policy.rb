class ChoiceQuestionPolicy < QuestionPolicy
  def permitted_attributes
    [:text, choice_question_options_attributes: [:id, :_destroy, :letter, :text]]
  end
end
