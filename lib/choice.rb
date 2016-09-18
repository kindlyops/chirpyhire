class Choice
  delegate :label, to: :feature
  def initialize(feature)
    @feature = feature
  end

  def option
    feature.properties['choice_option']
  end

  private

  attr_reader :feature
end
