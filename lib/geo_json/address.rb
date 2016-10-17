class GeoJson::Address
  extend ActionView::Helpers::DateHelper

  def self.features(candidates)
    candidates = candidates.select { |c| c.address.present? }.compact
    candidates.map(&method(:build_feature))
  end

  private

  def self.build_feature(candidate)
    {
      type: 'Feature',
      properties: properties(candidate),
      geometry: geometry(candidate)
    }
  end

  def self.properties(candidate)
    {
      description: description(candidate),
      stage_id: candidate.stage_id,
      stage_name: candidate.stage.name
    }
  end

  def self.geometry(candidate)
    {
      type: 'Point',
      coordinates: [candidate.address.longitude, candidate.address.latitude]
    }
  end

  def self.description(candidate)
    "<h3>Candidate: <a href='/users/#{candidate.user_id}/messages'>\
      #{candidate.phone_number}</a></h3>\
    <p class='handle sub-header'>#{candidate.handle}</p>
    <p>Address: #{candidate.address.formatted_address}</p>\
    <p>Created: #{time_ago_in_words(candidate.created_at)} ago</p>"
  end
end
