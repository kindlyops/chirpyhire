class Broadcaster::Conversation
  def self.broadcast(conversation)
    new(conversation).broadcast
  end

  def initialize(conversation)
    @conversation = conversation
  end

  def broadcast
    ConversationsChannel.broadcast_to(conversation, conversation_hash)
  end

  private

  attr_reader :conversation

  def conversation_hash
    JSON.parse(conversation_string)
  end

  def conversation_string
    ConversationsController.render partial: 'conversations/conversation',
                                   locals: {
                                     conversation: conversation.decorate
                                   }
  end
end
