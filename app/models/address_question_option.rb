class AddressQuestionOption < ApplicationRecord
  belongs_to :address_question,
             class_name: 'AddressQuestion',
             foreign_key: :question_id, inverse_of: :address_question_option

  validates :distance,
            numericality: { greater_than: 0 }
  validates :latitude,
            numericality: {
              greater_than_or_equal_to: -90, less_than_or_equal_to: 90
            }
  validates :longitude,
            numericality: {
              greater_than_or_equal_to: -180, less_than_or_equal_to: 180
            }

  validates :distance, :latitude, :longitude, presence: true
end
