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
    @message = scoped_messages.build(permitted_attributes(Message))
    if @message.valid?
      authorize @message
      @message.relay

      respond_to do |format|
        format.js {}
      end
    end
  end

  private

  def scoped_messages
    MessagePolicy::Scope.new(recipient, Message).resolve
  end

  def recipient
    @recipient ||= User.find(params[:user_id])
  end
end
