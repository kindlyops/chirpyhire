class Conversation
  include Draper::Decoratable

  def initialize(subscriber)
    @subscriber = subscriber
  end

  attr_reader :subscriber

  delegate :id, :person, :messages, to: :subscriber
  delegate :handle, to: :person, prefix: true
  delegate :last_reply_at, to: :messages

  def recently_replied?
    last_reply_at > 24.hours.ago
  end
end
