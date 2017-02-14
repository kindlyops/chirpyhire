class MessagesController < ApplicationController
  decorates_assigned :message, :messages, :user
  rescue_from Pundit::NotAuthorizedError, with: :message_not_authorized

  def index
    @messages = scoped_messages.by_recency.page(params.fetch(:page, 1))

    if message_user.has_unread_messages? && !impersonated
      message_user.update(has_unread_messages: false)
    end

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def create
    @message = scoped_messages.build

    create_message if authorize @message
  end

  private

  def create_message
    @message = send_message
    redirect_to user_messages_url(message_user), notice: 'Message sent!'
  end

  def send_message
    @sent_message ||= begin
      message_user.receive_message(
        body: params[:message][:body]
      )
    end
  end

  def scoped_messages
    policy_scope(Message).where(user: message_user)
  end

  def message_user
    @user ||= fetch_message_user
  end

  def fetch_message_user
    user = User.find(params[:user_id])
    return user if UserPolicy.new(current_organization, user).show?
    raise Pundit::NotAuthorizedError
  end

  def message_not_authorized
    redirect_to user_messages_url(message_user), alert: 'Unfortunately '\
    "they are unsubscribed! You can't text unsubscribed candidates "\
    'using ChirpyHire.'
  end
end
