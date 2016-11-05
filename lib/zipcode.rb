class Zipcode < FeatureViewModel
  delegate :label, to: :feature
  def option
    feature.properties['option']
  end
end
