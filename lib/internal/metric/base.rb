class Internal::Metric::Base
  def initialize(weeks)
    @weeks = weeks
  end

  attr_reader :weeks
end
