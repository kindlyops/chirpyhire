class TriggersPresenter
  include Enumerable

  def initialize(triggers)
    @triggers = triggers.map(&method(:wrap))
  end

  def each(&block)
    triggers.each(&block)
  end

  private

  def wrap(trigger)
    TriggerPresenter.new(trigger)
  end

  attr_reader :triggers
end
