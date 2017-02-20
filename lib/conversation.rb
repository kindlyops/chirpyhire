class Conversation
  def initialize(subscriber)
    @subscriber = subscriber
  end

  delegate :id, to: :subscriber

  private

  attr_reader :subscriber
end
