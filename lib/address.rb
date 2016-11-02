class Address
  delegate :id, :label, to: :feature

  def initialize(feature)
    @feature = feature
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

  def zipcode
    feature['properties']['postal_code']
  end

  private

  attr_reader :feature
end
