class InboxConversationsController < ApplicationController
  decorates_assigned :inbox_conversations

  def index
    @inbox_conversations = policy_scope(inbox.recent_inbox_conversations)

    respond_to do |format|
      format.json
    end
  end

  private

  def inbox
    @inbox ||= authorize(Inbox.find(params[:inbox_id]), :show?)
  end
end
