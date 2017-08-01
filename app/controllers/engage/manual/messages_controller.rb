class Engage::Manual::MessagesController < ApplicationController
  def create
    @new_manual_message = authorize new_manual_message

    send_notification if @new_manual_message.save
    head :ok
  end

  private

  def new_manual_message
    current_account.manual_messages.build(permitted_attributes(ManualMessage))
  end

  def send_notification
    Broadcaster::Notification.broadcast(current_account, notification)
  end

  def notification
    {
      message: 'Your message is now sending',
      key: SecureRandom.uuid
    }
  end
end
