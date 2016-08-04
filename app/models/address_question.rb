class AddressQuestion < Question
  has_one :address_question_option, foreign_key: :question_id, inverse_of: :address_question

  def self.extract(message, inquiry)
    question = inquiry.question
    address = message.address
    {
      address: address.address,
      latitude: address.latitude,
      longitude: address.longitude,
      postal_code: address.postal_code,
      country: address.country,
      city: address.city,
      child_class: "address"
    }
  end

  def has_geofence?
    address_question_option.present?
  end

  def uri
    "#{ENV.fetch("ADDRESS_URI_BASE")}/v4/mapbox.emerald/pin-s-marker+000000(#{coordinates.last},#{coordinates.first})/#{coordinates.last},#{coordinates.first},10/300x300@2x.png?access_token=#{ENV.fetch('MAPBOX_ACCESS_TOKEN')}"
  end

  def distance_in_miles
    return unless has_geofence?
    address_question_option.distance
  end

  def coordinates
    return [] unless has_geofence?
    [address_question_option.latitude, address_question_option.longitude]
  end
end
