class Broadcaster::Sidebar
  def initialize(account)
    @account = account
  end

  def broadcast
    SidebarChannel.broadcast_to(account, render_sidebar)
  end

  private

  attr_reader :account

  def render_sidebar
    MessagesController.render partial
  end

  def partial
    {
      partial: 'messages/sidebar/conversations',
      locals: {
        current_account: account
      }
    }
  end
end
