class Choice < FeatureViewModel
  def option
    feature.properties['choice_option']
  end
end
