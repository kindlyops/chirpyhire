class Engage::Manual::MessagesController < ApplicationController

  def create
    Broadcaster::Notification.broadcast(current_account, notification)

    head :ok
  end

  private

  def notification
    {
      message: 'Your message is now sending',
      key: SecureRandom.uuid
    }
  end
end
