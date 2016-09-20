class GeoJson::Candidates
  include ActionView::Helpers::DateHelper
  def initialize(candidates)
    @candidates = candidates
  end

  def call
    { type: 'FeatureCollection',
      features: features,
      statuses: Candidate::STATUSES }
  end

  private

  attr_reader :candidates

  def features
    candidates.map(&method(:feature)).compact
  end

  def feature(candidate)
    return unless candidate.address.present?

    {
      type: 'Feature',
      properties: {
        description: description(candidate),
        status: candidate.status
      },
      geometry: {
        type: 'Point',
        coordinates: [longitude(candidate), latitude(candidate)]
      }
    }
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
    "<h3>Candidate: <a href='/users/#{candidate.user_id}/messages'>#{candidate.handle}</a></h3><p>Address: #{address(candidate)}</p><p>Created: #{time_ago_in_words(candidate.created_at)} ago</p>"
  end
end
