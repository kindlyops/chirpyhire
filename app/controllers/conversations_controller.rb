class ConversationsController < ApplicationController
  decorates_assigned :conversations

  def index
    @conversations = scoped_conversations.page(params.fetch(:page, 1))
  end

  private

  def scoped_conversations
    policy_scope(Message)
  end
end
