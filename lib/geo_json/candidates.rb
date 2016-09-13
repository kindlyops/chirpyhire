class GeoJson::Candidates
  include ActionView::Helpers::DateHelper
  def initialize(candidates)
    @candidates = candidates
    @stage_ids = candidates.first.organization.stages.map(&:id)
  end

  def call
    { type: "FeatureCollection",
      features: build_features,
      stage_ids: @stage_ids
    }
  end

  private

  def build_features
    @candidates.map(&method(:build_feature)).compact
  end

  def build_feature(candidate)
    return unless candidate.address.present? && candidate.stage.present?

    {
      type: "Feature",
      properties: {
        description: description(candidate),
        stage_id: candidate.stage_id,
      },
      geometry: {
        type: "Point",
        coordinates: [candidate.address.longitude, candidate.address.latitude]
      }
    }
  end

  def description(candidate)
    "<h3>Candidate: <a href='/users/#{candidate.user_id}/messages'>#{candidate.handle}</a></h3><p>Address: #{candidate.address.formatted_address}</p><p>Created: #{time_ago_in_words(candidate.created_at)} ago</p>"
  end
end
