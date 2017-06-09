class Conversations::MessagesController < ApplicationController
  decorates_assigned :messages

  def index
    @messages = policy_scope(conversation.messages.by_recency)
    read_messages unless impersonating?
    inbox_conversation.update(last_viewed_at: DateTime.current)
    Broadcaster::InboxConversation.broadcast(inbox_conversation)

    respond_to do |format|
      format.json
    end
  end

  def create
    @conversation = authorized_conversation
    @message = scoped_messages.build
    create_message if @message.valid? && authorize(@message)

    head :ok
  end

  private

  def authorized_conversation
    authorize(Conversation.find(params[:conversation_id]), :show?)
  end

  def scoped_messages
    policy_scope(Message).where(
      recipient: @conversation.person,
      sender: current_account.person,
      conversation: @conversation
    )
  end

  def create_message
    current_organization.message(
      sender: current_account.person,
      contact: @conversation.contact,
      body: body
    )
  end

  def body
    params[:message][:body]
  end

  def read_messages
    inbox_conversation.read_receipts.unread.each(&:read)
  end

  def inbox_conversation
    @inbox_conversation ||= begin
      conversation.inbox_conversations.find_by(inbox: current_inbox)
    end
  end

  def conversation
    @conversation ||= begin
      authorize(Conversation.find(params[:conversation_id]), :show?)
    end
  end
end
