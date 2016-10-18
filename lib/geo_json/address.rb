class GeoJson::Address
  def self.features(candidates)
    candidates = candidates.select { |c| c.address.present? }.compact
    candidates.map(&method(:build_feature))
  end

  def self.build_feature(candidate)
    {
      type: GeoJson::FEATURE_TYPE,
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
    location = "<p>Address: #{candidate.address.formatted_address}</p>"
    GeoJson.single_description(candidate, candidate_location_p_tag: location)
  end

  private_class_method :build_feature, :properties, :geometry
end
