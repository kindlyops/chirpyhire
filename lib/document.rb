class Document < FeatureViewModel
  def uris
    feature.properties.select { |k, _| k['url'] }.values
  end
end
