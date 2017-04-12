class MessagesController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :message_not_authorized
  skip_after_action :verify_policy_scoped, only: :index
  layout 'messages', only: 'index'

  def index; end

  def create
    @message = scoped_messages.build
    create_message if authorize @message

    head :ok
  end

  private

  def create_message
    current_organization.message(
      recipient: conversation.person,
      body: body,
      manual: true
    )
  end

  def body
    params[:message][:body]
  end

  def scoped_messages
    policy_scope(Message).where(
      person: conversation.person,
      organization: current_organization
    )
  end

  def conversation
    @conversation ||= begin
      conversation = Conversation.new(Contact.find(params[:contact_id]))
      authorize conversation, :show?
    end
  end

  delegate :contact, to: :conversation

  def message_not_authorized
    redirect_to contact_conversation_path(contact), alert: error_message
  end

  def error_message
    "Unfortunately #{conversation.person_handle} has unsubscribed! You can't "\
    'text them using ChirpyHire.'
  end
end
