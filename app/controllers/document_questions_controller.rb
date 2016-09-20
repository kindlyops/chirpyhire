class DocumentQuestionsController < QuestionsController
  private

  def permitted_question_attributes
    permitted_attributes(DocumentQuestion)
  end

  def authorized_question
    authorize DocumentQuestion.find(params[:id])
  end

  def built_question_params
    super.merge(type: 'DocumentQuestion')
  end
end
