class GeoJson::Candidates
  include ActionView::Helpers::DateHelper
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
        description: description(candidate)
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

  def description(candidate)
    "<h3>Phone: <a href='tel:#{candidate.phone_number}'>#{phone_number(candidate)}</a></h3><p>Address: #{address(candidate)}</p><p>Created: #{time_ago_in_words(candidate.created_at)} ago</p>"
  end
end
