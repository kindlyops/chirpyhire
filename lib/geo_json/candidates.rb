class GeoJson::Candidates

  def initialize(candidates)
    @candidates = candidates
  end

  def call
    { type: "FeatureCollection",
      features: features
    }
  end

  private

  attr_reader :candidates

  def features
    candidates.map(&method(:feature)).compact
  end

  def feature(candidate)
    return unless candidate.address.present?

    {
      type: "Feature",
      properties: {
        phone_number: phone_number(candidate),
        address: address(candidate),
        status: candidate.status
      },
      geometry: {
        type: "Point",
        coordinates: [longitude(candidate), latitude(candidate)]
      }
    }
  end

  def phone_number(candidate)
    candidate.phone_number.phony_formatted
  end

  def address(candidate)
    candidate.address.formatted_address
  end

  def longitude(candidate)
    candidate.address.longitude
  end

  def latitude(candidate)
    candidate.address.latitude
  end
end
