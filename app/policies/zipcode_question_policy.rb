class ZipcodeQuestionPolicy < QuestionPolicy
  def permitted_attributes
    super.push(zipcode_question_options_attributes: [:id, :_destroy, :text])
  end
end
