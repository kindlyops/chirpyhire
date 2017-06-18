class ConversationsController < ApplicationController
  layout 'conversations', only: %i[show index]
  decorates_assigned :conversation
  decorates_assigned :conversations

  def index
    @conversations = policy_scope(inbox.recent_conversations)

    respond_to do |format|
      format.html { render html: '', layout: true }
      format.json
    end
  end

  def show
    @conversation = authorize(inbox.conversations.find(params[:id]))

    respond_to do |format|
      format.html { render html: '', layout: true }
    end
  end

  def update
    @conversation = authorize(inbox.conversations.find(params[:id]))
    @conversation.update(permitted_attributes(Conversation))

    head :ok
  end

  private

  def inbox
    @inbox ||= authorize(Inbox.find(params[:inbox_id]), :show?)
  end
end
