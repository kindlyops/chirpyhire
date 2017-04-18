class MessagesController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :message_not_authorized
  skip_after_action :verify_policy_scoped, only: :index
  layout 'messages', only: 'index'

  before_action :ensure_contacts, only: :index

  def index
    if current_conversation_id.present?
      redirect_to message_path(current_conversation_id)
    else
      redirect_to message_path(most_recent_conversation)
    end
  end

  def show
    set_current_conversation
    @conversation = conversation
  end

  def create
    @message = scoped_messages.build
    create_message if authorize @message

    head :ok
  end

  private

  def set_current_conversation
    cookies.signed['current_conversation_id'] = {
      value: conversation.id,
      expires: 100.years.from_now
    }
  end

  def most_recent_conversation
    current_organization.contacts.recently_replied.first
  end

  def current_conversation_id
    cookies.signed['current_conversation_id']
  end

  def ensure_contacts
    no_contacts_message if current_organization.contacts.empty?
  end

  def no_contacts_message
    flash[:notice] = 'No caregivers to message yet.'
    redirect_to root_path
  end

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
