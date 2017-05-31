class ConversationsController < ApplicationController
  PAGE_LIMIT = 25
  layout 'conversations', only: %i[show index]
  decorates_assigned :conversation

  def index
    @conversations = paginated(policy_scope(recent_conversations))

    if inbox.conversations.exists?
      respond_to do |format|
        format.json
        format.html { redirect_to current_conversation_path }
      end
    else
      render :index
    end
  end

  def show
    @conversation = authorize(inbox.conversations.find(params[:id]))
    read_messages unless impersonating?
    inbox_conversation.update(last_viewed_at: DateTime.current)
  end

  private

  delegate :inbox_conversations, to: :inbox

  def recent_conversations
    inbox.conversations.by_recent_message
  end

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

  def paginated(scope)
    scope.page(page).per(PAGE_LIMIT)
  end

  def page
    params[:page].to_i || 1
  end
end
