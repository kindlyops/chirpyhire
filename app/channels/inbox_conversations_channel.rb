class InboxConversationsChannel < ApplicationCable::Channel
  def subscribed
    reject if inbox.blank?
    stream_for inbox
  end

  private

  def inbox
    @inbox ||= authorize(current_account.inbox)
  end
end
