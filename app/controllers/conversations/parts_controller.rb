class Conversations::PartsController < ApplicationController
  decorates_assigned :parts

  def index
    @parts = policy_scope(parts_scope)
    read_receipts unless impersonating?
    Broadcaster::Conversation.broadcast(conversation)

    respond_to do |format|
      format.json
    end
  end

  def create
    @conversation = authorized_conversation
    return head :ok if @conversation.closed?

    @message = scoped_messages.build
    create_part if @message.valid? && authorize(@message)
    head :ok
  end

  private

  def create_part
    message = create_message

    @conversation.parts.create(
      message: message,
      happened_at: message.external_created_at
    ).tap(&:touch_conversation)
  end

  def parts_scope
    conversation.parts.by_oldest.includes(message: :sender)
  end

  def read_receipts
    conversation.read_receipts.unread.each(&:read)
  end

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
      recipient: @conversation.contact.person,
      phone_number: @conversation.phone_number,
      body: body
    )
  end

  def body
    params[:message][:body]
  end

  def conversation
    @conversation ||= begin
      authorize(Conversation.find(params[:conversation_id]), :show?)
    end
  end
end
