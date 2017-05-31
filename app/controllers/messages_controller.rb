class MessagesController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :message_not_authorized
  skip_after_action :verify_policy_scoped, only: :index
  decorates_assigned :conversation

  def create
    @conversation = authorize fetch_conversation, :show?
    @message = scoped_messages.build
    create_message if authorize @message

    head :ok
  end

  def index
    redirect_to conversations_path
  end

  def show
    @conversation = authorize fetch_conversation, :show?

    redirect_to conversation_path
  end

  private

  def conversations_path
    inbox_conversations_path(current_inbox)
  end

  def conversation_path
    inbox_conversation_path(current_inbox, @conversation)
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
    redirect_to conversation_path, alert: error_message
  end

  def error_message
    "Unfortunately #{@conversation.handle} has unsubscribed! You can't "\
    'text them using ChirpyHire.'
  end
end
