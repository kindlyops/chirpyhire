class GeoJson::Candidates
  include ActionView::Helpers::DateHelper
  def initialize(candidates)
    @candidates = candidates
    @stages = stages.map { |stage| { id: stage.id, name: stage.name } }
  end

  def call
    { type: 'FeatureCollection',
      features: build_features,
      stages: @stages }
  end

  private

  attr_reader :candidates

  def build_features
    @candidates.map(&method(:build_feature)).compact
  end

  def build_feature(candidate)
    return unless candidate.address.present? && candidate.stage.present?
    {
      type: 'Feature',
      properties: properties(candidate),
      geometry: geometry(candidate)
    }
  end

  def properties(candidate)
    {
      description: description(candidate),
      stage_id: candidate.stage_id,
      stage_name: candidate.stage.name
    }
  end

  def geometry(candidate)
    {
      type: 'Point',
      coordinates: [candidate.address.longitude, candidate.address.latitude]
    }
  end

  def stages
    candidates.first.stages
  end

  def description(candidate)
    "<h3>Candidate: <a href='/users/#{candidate.user_id}/messages'>\
      #{candidate.handle}</a></h3>\
    <p>Address: #{candidate.address.formatted_address}</p>\
    <p>Created: #{time_ago_in_words(candidate.created_at)} ago</p>"
  end
end
