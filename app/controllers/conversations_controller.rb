class ConversationsController < ApplicationController
  layout 'conversations', only: %i[show index]
  decorates_assigned :conversation
  decorates_assigned :conversations

  def index
    @conversations = policy_scope(inbox.recent_conversations)

    if @conversations.exists?
      redirect_to current_conversation_path
    else
      render :index
    end
  end

  def show
    @conversation = authorize(inbox.conversations.find(params[:id]))

    respond_to do |format|
      format.json
      format.html { render html: '', layout: true }
    end
  end

  private

  delegate :inbox_conversations, to: :inbox

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
