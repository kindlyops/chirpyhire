class Document < FeatureViewModel
  def first_page
    feature.properties['url0']
  end

  def uris
    feature.properties.select { |k, _| k['url'] }.values
  end

  def additional_uris
    uris.drop(1)
  end
end
