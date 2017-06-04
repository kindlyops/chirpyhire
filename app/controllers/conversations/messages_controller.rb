class Conversations::MessagesController < ApplicationController
  decorates_assigned :messages

  def index
    @messages = policy_scope(conversation.messages)

    respond_to do |format|
      format.json
    end
  end

  private

  def conversation
    @conversation ||= begin
      authorize(Conversation.find(params[:conversation_id]), :show?)
    end
  end
end
