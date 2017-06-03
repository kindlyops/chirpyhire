class Broadcaster::Message
  def self.broadcast(message)
    new(message).broadcast
  end

  def initialize(message)
    @message = message
  end

  def broadcast
    MessagesChannel.broadcast_to(conversation, message_hash)
  end

  private

  attr_reader :message

  delegate :conversation, to: :message

  def message_hash
    JSON.parse(message_string)
  end

  def message_string
    MessagesController.render partial: 'messages/message', locals: {
      message: message
    }
  end
end
