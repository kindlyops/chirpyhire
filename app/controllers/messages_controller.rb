class MessagesController < ApplicationController
  decorates_assigned :message
  decorates_assigned :user

  def new
    message = scoped_messages.build

    @message = authorize message

    respond_to do |format|
      format.js {}
    end
  end

  def create
    message = user.receive_message(body: params[:body])
    @message = authorize message

    respond_to do |format|
      format.js {}
    end
  end

  private

  def scoped_messages
    policy_scope(Message).where(user: user)
  end

  def user
    @user ||= begin
      user = User.find(params[:user_id])
      if UserPolicy.new(current_account, user).show?
        user
      else
        raise Pundit::NotAuthorizedError
      end
    end
  end
end
