class ConversationsController < ApplicationController
  decorates_assigned :conversation

  def show
    @conversation = authorize fetch_conversation
  end

  private

  def fetch_conversation
    Conversation.new(Subscriber.find(params[:subscriber_id]))
  end
end
