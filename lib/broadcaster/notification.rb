class Broadcaster::Notification
  def self.broadcast(account, notification)
    new(account, notification).broadcast
  end

  def initialize(account, notification)
    @account = account
    @notification = notification
  end

  def broadcast
    NotificationsChannel.broadcast_to(account, notification)
  end

  private

  attr_reader :account, :notification
end
