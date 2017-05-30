class MessagesController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :message_not_authorized
  layout 'messages', only: 'index'
  decorates_assigned :conversation

  def index
    @conversations = policy_scope(Conversation)

    if current_account.inbox_conversations.exists?
      redirect_to_recent_conversation
    else
      render :index
    end
  end

  def show
    @conversation = authorize fetch_conversation, :show?
    read_messages unless impersonating?
    inbox_conversation.update(last_viewed_at: DateTime.current)
  end

  def create
    @conversation = authorize fetch_conversation, :show?
    @message = scoped_messages.build
    create_message if authorize @message

    head :ok
  end

  private

  def read_messages
    inbox_conversation.read_receipts.unread.each(&method(:read))
  end

  def inbox_conversation
    @inbox_conversation ||= begin
      current_account.inbox_conversations.find_by(conversation: @conversation)
    end
  end

  def redirect_to_recent_conversation
    redirect_to message_path(current_conversation.contact)
  end

  def current_conversation
    current_account.inbox_conversations.recently_viewed.first
  end

  def read(receipt)
    receipt.update(read_at: DateTime.current)
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

  def scoped_messages
    policy_scope(Message).where(
      recipient: @conversation.person,
      sender: current_account.person,
      conversation: @conversation
    )
  end

  def fetch_conversation
    current_account.conversations.find_by(contact: contact)
  end

  def contact
    @contact ||= Contact.find(params[:contact_id])
  end

  def message_not_authorized
    redirect_to message_path(contact), alert: error_message
  end

  def error_message
    "Unfortunately #{@conversation.handle} has unsubscribed! You can't "\
    'text them using ChirpyHire.'
  end
end
