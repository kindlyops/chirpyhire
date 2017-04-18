class MessagesController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :message_not_authorized

  def create
    @message = scoped_messages.build
    create_message if authorize @message

    head :ok
  end

  private

  def create_message
    current_organization.message(
      sender: current_account.person,
      recipient: conversation.person,
      body: body
    )
  end

  def body
    params[:message][:body]
  end

  def scoped_messages
    policy_scope(Message).where(
      recipient: conversation.person,
      sender: current_account.person,
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
