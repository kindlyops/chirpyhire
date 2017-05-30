class ConversationsController < ApplicationController
  PAGE_LIMIT = 25
  layout 'messages', only: 'show'
  decorates_assigned :conversation

  def index
    @conversations = paginated(policy_scope(conversations))

    respond_to do |format|
      format.json
      format.html { redirect_to current_conversation_path }
    end
  end

  def show
    @conversation = authorize(conversations.find(params[:id]))
  end

  private

  delegate :conversations, :inbox_conversations, to: :inbox

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
