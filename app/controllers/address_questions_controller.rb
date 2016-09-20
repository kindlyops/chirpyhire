class AddressQuestionsController < QuestionsController
  private

  def permitted_question_attributes
    permitted_attributes(AddressQuestion)
  end

  def authorized_question
    authorize AddressQuestion.find(params[:id])
  end

  def built_question_params
    super.merge(type: 'AddressQuestion', address_question_option_attributes: { distance: 10, latitude: current_organization.latitude, longitude: current_organization.longitude })
  end
end
