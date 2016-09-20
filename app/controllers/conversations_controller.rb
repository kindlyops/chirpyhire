class ConversationsController < ApplicationController
  decorates_assigned :conversations
  skip_after_action :verify_policy_scoped, only: :index

  def index
    @conversations = conversations_by_read_status_and_recency
  end

  private

  def scoped_conversations
    ConversationPolicy::Scope.new(current_organization, Message).resolve
  end

  def conversations_by_read_status_and_recency
    scoped_conversations.by_read_status.by_recency.page(params.fetch(:page, 1))
  end
end
