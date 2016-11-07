class YesNo < FeatureViewModel
  def option
    feature.properties['yes_no_option']
  end
end
