class ConversationsController < ApplicationController
  layout 'conversations', only: %i[show index]
  decorates_assigned :conversation
  decorates_assigned :conversations

  def index
    @conversations = policy_scope(inbox.recent_conversations)

    if @conversations.exists?
      redirect_to existing_open_conversation_path
    else
      render :index
    end
  end

  def show
    @conversation = authorize(inbox.conversations.find(params[:id]))
    inbox_conversation.update(last_viewed_at: DateTime.current)

    respond_to do |format|
      format.html { render html: '', layout: true }
    end
  end

  def update
    @conversation = authorize(inbox.conversations.find(params[:id]))

    @conversation.update(permitted_attributes(Conversation))
    notifiable_inbox_conversations.find_each do |inbox_conversation|
      Broadcaster::InboxConversation.broadcast(inbox_conversation)
    end

    head :ok
  end

  private

  delegate :inbox_conversations, to: :inbox

  def notifiable_inbox_conversations
    contact = @conversation.contact
    team_inbox_conversations = @conversation.team.inbox_conversations
    team_inbox_conversations.where(conversation: contact.conversations)
  end

  def inbox_conversation
    inbox_conversations.find_by(conversation: @conversation)
  end

  def existing_open_conversation_path
    inbox_conversation_path(inbox, existing_open_conversation)
  end

  def existing_open_conversation
    inbox_conversations.recently_viewed.first.conversation
  end

  def inbox
    @inbox ||= authorize(Inbox.find(params[:inbox_id]), :show?)
  end
end
