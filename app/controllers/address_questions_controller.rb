class AddressQuestionsController < QuestionsController
  private

  def built_question_params
    super.merge(
      address_question_option_attributes: {
        distance: 10,
        latitude: current_organization.latitude,
        longitude: current_organization.longitude
      }
    )
  end
end
