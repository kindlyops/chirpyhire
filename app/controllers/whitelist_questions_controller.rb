class WhitelistQuestionsController < QuestionsController
  private

  def permitted_question_attributes
    permitted_attributes(WhitelistQuestion).merge(updated_at: Time.current)
  end

  def authorized_question
    authorize WhitelistQuestion.find(params[:id])
  end

  def built_question_params
    super.merge(type: 'WhitelistQuestion')
  end
end
