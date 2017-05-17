class Inboxes::ConversationsController < ApplicationController
  
  def show
    @conversation = authorize(inbox.conversations.find(params[:id]))
  end

  private

  def inbox
    @inbox ||= authorize(Inbox.find(params[:inbox_id]))
  end
end
