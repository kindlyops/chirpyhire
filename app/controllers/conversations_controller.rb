class ConversationsController < ApplicationController
  PAGE_LIMIT = 25

  def index
    @conversations = paginated(policy_scope(inbox_conversations))

    respond_to do |format|
      format.json
    end
  end

  private

  def inbox_conversations
    inbox.inbox_conversations.joins(contact: :person).recently_viewed.by_handle
  end

  def inbox
    @inbox ||= authorize(Inbox.find(params[:inbox_id]), :show?)
  end

  def paginated(scope)
    scope.page(page).per(PAGE_LIMIT)
  end

  def page
    params[:page].to_i || 1
  end
end
