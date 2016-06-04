class MessagesController < ApplicationController
  decorates_assigned :message, :user, :messages

  def index
    @messages = scoped_messages.order(created_at: :desc)

    render layout: false
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
