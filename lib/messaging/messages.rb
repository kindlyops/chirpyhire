class Messaging::Messages
  def initialize(messages)
    @messages = messages
  end

  def get(sid)
    Messaging::Message.new(messages.get(sid))
  end

  private

  attr_reader :messages
end
