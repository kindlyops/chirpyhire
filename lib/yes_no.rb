class YesNo
  delegate :label, to: :feature
  def initialize(feature)
    @feature = feature
  end

  def option
    feature.properties['yes_no_option']
  end

  private

  attr_reader :feature
end
