class Conversations::MessagesController < ApplicationController
  decorates_assigned :messages

  def index
    @messages = policy_scope(conversation.messages.by_recency)
    read_messages unless impersonating?
    inbox_conversation.update(last_viewed_at: DateTime.current)
    Broadcaster::InboxConversation.broadcast(inbox_conversation)

    respond_to do |format|
      format.json
    end
  end

  private

  def read_messages
    inbox_conversation.read_receipts.unread.each(&:read)
  end

  def inbox_conversation
    @inbox_conversation ||= begin
      conversation.inbox_conversations.find_by(inbox: current_inbox)
    end
  end

  def conversation
    @conversation ||= begin
      authorize(Conversation.find(params[:conversation_id]), :show?)
    end
  end
end
