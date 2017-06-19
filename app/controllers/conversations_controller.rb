class ConversationsController < ApplicationController
  layout 'conversations', only: %i[show index]
  decorates_assigned :conversation
  decorates_assigned :conversations

  before_action :handle_old_account_inboxes, only: :show

  def index
    @conversations = policy_scope(
      inbox.recent_conversations.includes(
        :recent_message, contact: %i[open_conversations person]
      )
    )

    respond_to do |format|
      format.html { render html: '', layout: true }
      format.json
    end
  end

  def show
    @conversation = authorize(inbox.conversations.find(params[:id]))

    respond_to do |format|
      format.html { render html: '', layout: true }
    end
  end

  def update
    @conversation = authorize(inbox.conversations.find(params[:id]))
    @conversation.update(permitted_attributes(Conversation))
    Broadcaster::Conversation.broadcast(@conversation)

    head :ok
  end

  private

  def handle_old_account_inboxes
    old_inbox = Inbox.find(params[:inbox_id])
    return if old_inbox.team_id.present?
    return if old_inbox.account_id != current_account.id
    team_inbox = fetch_team_inbox
    return if team_inbox.blank?
    redirect_to team_inbox_conversation_path(team_inbox)
  end

  def team_inbox_conversation_path(team_inbox)
    inbox_conversation_path(team_inbox, Conversation.find(params[:id]))
  end

  def fetch_team_inbox
    current_organization.inboxes.find do |inbox|
      inbox.conversations.find_by(id: params[:id])
    end
  end

  def inbox
    @inbox ||= authorize(Inbox.find(params[:inbox_id]), :show?)
  end
end
