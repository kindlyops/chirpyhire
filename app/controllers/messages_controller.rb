class MessagesController < ApplicationController
  decorates_assigned :message

  def new
    message = scoped_messages.build

    @message = authorize message

    respond_to do |format|
      format.js {}
    end
  end

  def create
    message = recipient.receive_message(body: params[:body])
    @message = authorize message

    respond_to do |format|
      format.js {}
    end
  end

  private

  def scoped_messages
    policy_scope(Message).where(user: recipient)
  end

  def recipient
    @recipient ||= begin
      recipient = User.find(params[:user_id])
      if UserPolicy.new(current_account, recipient).show?
        recipient
      else
        raise Pundit::NotAuthorizedError
      end
    end
  end
end
