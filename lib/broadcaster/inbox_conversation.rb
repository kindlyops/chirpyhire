class Broadcaster::InboxConversation
  def self.broadcast(inbox_conversation)
    new(inbox_conversation).broadcast
  end

  def initialize(inbox_conversation)
    @inbox_conversation = inbox_conversation
  end

  def broadcast
    InboxConversationsChannel.broadcast_to(inbox, inbox_conversation_hash)
  end

  private

  attr_reader :inbox_conversation
  delegate :inbox, to: :inbox_conversation

  def inbox_conversation_hash
    JSON.parse(inbox_conversation_string)
  end

  def inbox_conversation_string
    ConversationsController.render render_options
  end

  def render_options
    {
      partial: 'inbox_conversations/inbox_conversation',
      locals: {
        inbox_conversation: inbox_conversation.decorate
      }
    }
  end
end
