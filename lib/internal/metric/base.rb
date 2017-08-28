class Internal::Metric::Base
  def initialize(stage, weeks)
    @stage = stage
    @weeks = weeks
    @scope = Contact.send(stage)
  end

  attr_reader :weeks, :stage, :scope

  def stage_title
    stage.to_s.titlecase
  end
end
