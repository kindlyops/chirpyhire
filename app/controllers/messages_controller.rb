class MessagesController < ApplicationController
  decorates_assigned :message, :messages, :user
  rescue_from Pundit::NotAuthorizedError, with: :message_not_authorized

  def index
    @messages = scoped_messages.by_recency.page(params.fetch(:page, 1))

    message_user.update(has_unread_messages: false) if message_user.has_unread_messages?

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def create
    @message = scoped_messages.build

    if authorize @message
      @message = send_message
      redirect_to user_messages_url(message_user), notice: "Message sent!"
    end
  end

  private

  def send_message
    @sent_message ||= message_user.receive_message(body: params[:message][:body])
  end

  def scoped_messages
    policy_scope(Message).where(user: message_user)
  end

  def message_user
    @user ||= begin
      message_user = User.find(params[:user_id])
      if UserPolicy.new(current_organization, message_user).show?
        message_user
      else
        raise Pundit::NotAuthorizedError
      end
    end
  end

  def message_not_authorized
    redirect_to user_messages_url(message_user), alert: "Unfortunately they are "\
    "unsubscribed! You can't text unsubscribed candidates using Chirpyhire."
  end
end
