class ConversationsController < ApplicationController
  decorates_assigned :conversations
  skip_after_action :verify_policy_scoped, only: :index

  def index
    @conversations = scoped_conversations.page(params.fetch(:page, 1)).sort_by(&:id).reverse
  end

  private

  def scoped_conversations
    ConversationPolicy::Scope.new(current_organization, Message).resolve
  end
end
