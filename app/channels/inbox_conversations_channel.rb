class InboxConversationsChannel < ApplicationCable::Channel
  def subscribed
    reject if current_account.inbox.blank?
    stream_for current_account.inbox
  end
end
