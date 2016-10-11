class WhitelistQuestionPolicy < QuestionPolicy
  def permitted_attributes
    super.push(
      whitelist_question_options_attributes: [:id, :_destroy, :text]
    )
  end
end
