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

  def initialize(feature)
    @feature = feature
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
