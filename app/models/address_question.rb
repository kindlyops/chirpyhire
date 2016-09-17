# frozen_string_literal: true
class AddressQuestion < Question
  has_one :address_question_option,
          foreign_key: :question_id, inverse_of: :address_question
  accepts_nested_attributes_for :address_question_option,
                                reject_if: :all_blank, allow_destroy: true
  delegate :latitude, :longitude, :distance, to: :address_question_option

  def self.extract(message, _inquiry)
    address = message.address
    {
      address: address.address,
      latitude: address.latitude,
      longitude: address.longitude,
      postal_code: address.postal_code,
      country: address.country,
      city: address.city,
      child_class: 'address'
    }
  end

  def rejects?(candidate)
    return false unless geofenced?
    distance_away(candidate) > distance
  end

  def geofenced?
    address_question_option.present?
  end

  def distance_in_miles
    return unless geofenced?
    address_question_option.distance
  end

  def coordinates
    return [] unless geofenced?
    [address_question_option.latitude, address_question_option.longitude]
  end

  def distance_away(candidate)
    Geocoder::Calculations.distance_between(
      candidate.address.coordinates, coordinates
    )
  end
end
