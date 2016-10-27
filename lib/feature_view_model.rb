class FeatureViewModel
  delegate :label, to: :feature
  def initialize(feature)
    @feature = feature
  end

  private

  attr_reader :feature
end
