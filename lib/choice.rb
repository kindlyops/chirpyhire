class Choice
  def initialize(feature)
    @feature = feature
  end

  def option
    feature.properties['choice_option']
  end

  def category
    feature.category.name
  end

  private

  attr_reader :feature
end
