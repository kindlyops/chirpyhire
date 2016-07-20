class Address
  def self.extract(message, persona_feature)
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

  delegate :id, to: :feature

  def initialize(feature)
    @feature = feature
  end

  def uri
    "#{URI_BASE}/v4/mapbox.emerald/pin-s-marker+000000(#{longitude},#{latitude})/#{longitude},#{latitude},11/300x400@2x.png?access_token=#{ENV.fetch('MAPBOX_ACCESS_TOKEN')}"
  end

  def coordinates
    return [] unless latitude.present? && longitude.present?
    [latitude, longitude]
  end

  def latitude
    feature['properties']['latitude']
  end

  def longitude
    feature['properties']['longitude']
  end

  def formatted_address
    feature['properties']['address']
  end

  private

  attr_reader :feature

end
