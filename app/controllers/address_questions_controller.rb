class AddressQuestionsController < QuestionsController

  def new
    @question = authorize(new_question)
  end

  def update
    if authorized_question.update(permitted_attributes(AddressQuestion))
      redirect_to survey_url, notice: "Nice! Question saved."
    else
      render :edit
    end
  end

  private

  def authorized_question
    authorize AddressQuestion.find(params[:id])
  end

  def new_question_params
    super.merge(type: "AddressQuestion", address_question_option_attributes: { distance: 10, latitude: current_organization.latitude, longitude: current_organization.longitude })
  end
end
