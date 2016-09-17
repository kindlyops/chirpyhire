# frozen_string_literal: true
class AddressQuestionPolicy < QuestionPolicy
  def permitted_attributes
    super.push(
      address_question_option_attributes: [
        :id, :_destroy, :distance, :latitude, :longitude
      ]
    )
  end
end
