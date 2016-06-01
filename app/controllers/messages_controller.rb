class MessagesController < ApplicationController
  decorates_assigned :message, :user

  def new
    message = scoped_messages.build

    @message = authorize message

    respond_to do |format|
      format.js {}
    end
  end

  def create
    message = message_user.receive_message(body: params[:body])
    @message = authorize message

    respond_to do |format|
      format.js {}
    end
  end

  private

  def scoped_messages
    policy_scope(Message).where(user: message_user)
  end

  def message_user
    @user ||= begin
      message_user = User.find(params[:user_id])
      if UserPolicy.new(current_account, message_user).show?
        message_user
      else
        raise Pundit::NotAuthorizedError
      end
    end
  end
end
