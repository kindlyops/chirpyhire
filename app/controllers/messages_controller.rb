class MessagesController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :message_not_authorized

  def create
    @message = scoped_messages.build

    if authorize @message
      create_message
    else
      render :new
    end
  end

  private

  def create_message
    current_organization.message(recipient: subscriber.person, body: body)
    notice = 'Message sent!'
    redirect_to subscriber_conversation_path(subscriber), notice: notice
  end

  def body
    params[:message][:body]
  end

  def scoped_messages
    policy_scope(Message).where(
      person: subscriber.person,
      organization: current_organization
    )
  end

  def subscriber
    @subscriber ||= authorize(Subscriber.find(params[:subscriber_id]))
  end

  def message_not_authorized
    redirect_to subscriber_conversation_path(subscriber), alert: error_message
  end

  def error_message
    "Unfortunately #{subscriber.handle} has unsubscribed! You can't text them "\
    'using ChirpyHire.'
  end
end
