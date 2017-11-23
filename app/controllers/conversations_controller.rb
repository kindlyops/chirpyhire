class ConversationsController < ApplicationController
  PAGE_LIMIT = 25
  layout 'conversations', only: %i[show index]
  decorates_assigned :conversation
  decorates_assigned :conversations

  before_action :handle_old_account_inboxes, only: :show
  before_action :ensure_not_canceled

  def index
    @conversations = policy_scope(
      paginated(state_filter(inbox.recent_conversations.includes(
                               recent_part: :message,
                               contact: %i[open_conversations person]
      )))
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
      format.json
    end
  end

  def update
    handle_closed_at
    @conversation = authorize(inbox.conversations.find(params[:id]))
    @conversation.update(permitted_attributes(Conversation))
    Broadcaster::Conversation.broadcast(@conversation)
    Broadcaster::Contact.broadcast(@conversation.contact)

    head :ok
  end

  private

  def handle_closed_at
    transform_closed_at if params[:conversation][:closed_at].present?
  end

  def transform_closed_at
    float_time = params[:conversation][:closed_at].to_i / 1000.0
    datetime = Time.zone.at(float_time).to_datetime
    params[:conversation][:closed_at] = datetime
  end

  def state_filter(scope)
    return scope if params[:state].blank?

    scope.where(state: params[:state])
  end

  def paginated(scope)
    scope.page(page).per(PAGE_LIMIT)
  end

  def page
    params[:page].to_i || 1
  end

  def ensure_not_canceled
    redirect_to billing_path, alert: billing_notice if canceled?
  end

  def billing_notice
    'Your trial has ended. To chat candidates please sign up for ChirpyHire.'
  end

  delegate :canceled?, to: :current_organization

  def billing_path
    organization_billing_company_path(current_organization)
  end

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
