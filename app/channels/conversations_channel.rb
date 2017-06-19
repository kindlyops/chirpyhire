class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    reject if inbox.blank?
    stream_for inbox
  end

  private

  def inbox
    @inbox ||= authorize(Inbox.find(params[:inbox_id]), :show?)
  end
end
