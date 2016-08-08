class DocumentQuestionsController < QuestionsController
  def update
    if authorized_question.update(permitted_attributes(DocumentQuestion))
      redirect_to survey_url, notice: "Nice! Question saved."
    else
      render :edit
    end
  end

  private

  def authorized_question
    authorize DocumentQuestion.find(params[:id])
  end

  def new_question_params
    super.merge(type: "AddressQuestion")
  end
end
