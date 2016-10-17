module GeoJson
  def self.build_sources(candidates)
    address_features = GeoJson::Address.features(candidates)
    zipcode_features = GeoJson::Zipcode.new(candidates).features
    stages = stage_models(candidates.first)

    address_source = build_source(address_features)
    zipcode_source = build_source(zipcode_features)
    { sources: [address_source, zipcode_source], stages: stages }
  end

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

  private_class_method :build_source, :stage_models
end
