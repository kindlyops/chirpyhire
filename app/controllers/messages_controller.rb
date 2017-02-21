class MessagesController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :message_not_authorized

  def create
    @message = scoped_messages.build

    create_message if authorize @message

    respond_to do |format|
      format.js {}
    end
  end

  private

  def create_message
    current_organization.message(
      recipient: conversation.person,
      body: body,
      manual: true
    )
    redirect_to subscriber_conversation_path(subscriber)
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
      conversation = Conversation.new(Subscriber.find(params[:subscriber_id]))
      authorize conversation, :show?
    end
  end

  delegate :subscriber, to: :conversation

  def message_not_authorized
    redirect_to subscriber_conversation_path(subscriber), alert: error_message
  end

  def error_message
    "Unfortunately #{conversation.person_handle} has unsubscribed! You can't "\
    'text them using ChirpyHire.'
  end
end
