class ConversationsCountsController < ApplicationController
  def show
    render json: conversations.count
  end

  private

  def conversations
    @conversations ||= begin
      policy_scope(state_filter(inbox.recent_conversations))
    end
  end

  def state_filter(scope)
    return scope if params[:state].blank?

    scope.where(state: params[:state])
  end

  def inbox
    @inbox ||= authorize(Inbox.find(params[:inbox_id]), :show?)
  end
end
