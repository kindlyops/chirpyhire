class ConversationsController < ApplicationController
  def show
    @conversation = authorize conversation
  end

  private

  def conversation
    Conversation.new(Subscriber.find(params[:subscriber_id]))
  end
end
