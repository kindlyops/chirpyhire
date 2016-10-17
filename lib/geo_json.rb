module GeoJson
  def self.build_sources(candidates)
    address_features = Address.features(candidates)
    zipcode_features = Zipcode.new(candidates).features
    stages = stage_models(candidates.first)

    address_source = build_source(address_features)
    zipcode_source = build_source(zipcode_features)
    { sources: [address_source, zipcode_source], stages: stages }
  end

  private
  # http://www.geojson.org
  def self.build_source(features)
    {
        type: 'FeatureCollection',
        features: features
    }
  end

  def self.stage_models(candidate)
    candidate.stages.map { |stage| { id: stage.id, name: stage.name } }
  end
end
