class ConversationsController < ApplicationController
  layout 'conversations', only: %i[show index]
  decorates_assigned :conversation
  decorates_assigned :conversations

  def index
    @conversations = policy_scope(inbox.recent_conversations)

    respond_to_index
  end

  def show
    @conversation = authorize(inbox.conversations.find(params[:id]))
    read_messages unless impersonating?
    inbox_conversation.update(last_viewed_at: DateTime.current)

    respond_to do |format|
      format.json
      format.html
    end
  end

  private

  def respond_to_index
    respond_to do |format|
      format.json
      format.html do
        if @conversations.exists?
          redirect_to current_conversation_path
        else
          render :index
        end
      end
    end
  end

  delegate :inbox_conversations, to: :inbox

  def read_messages
    inbox_conversation.read_receipts.unread.each(&:read)
  end

  def inbox_conversation
    inbox.inbox_conversations.find_by(conversation: @conversation)
  end

  def current_conversation_path
    inbox_conversation_path(inbox, current_conversation)
  end

  def current_conversation
    inbox_conversations.recently_viewed.first.conversation
  end

  def inbox
    @inbox ||= authorize(Inbox.find(params[:inbox_id]), :show?)
  end
end
