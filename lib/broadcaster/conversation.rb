class Broadcaster::Conversation
  def self.broadcast(conversation)
    new(conversation).broadcast
  end

  def initialize(conversation)
    @conversation = conversation
  end

  def broadcast
    ConversationsChannel.broadcast_to(inbox, conversation_hash)
  end

  private

  attr_reader :conversation

  def conversation_hash
    JSON.parse(conversation_string)
  end

  def conversation_string
    ConversationsController.render partial: partial, locals: {
      conversation: conversation.decorate
    }
  end

  def partial
    'conversations/conversation'
  end

  delegate :inbox, to: :conversation
end
