class Notification::Base
  def initialize(subscriber)
    @subscriber = subscriber
  end

  attr_reader :subscriber
  delegate :organization, to: :subscriber
end
