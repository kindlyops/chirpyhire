class MessagesChannel < ApplicationCable::Channel
  def subscribed
    reject if conversation.blank?
    stream_for conversation
  end

  delegate :conversations, to: :current_account

  private

  def conversation
    @conversation ||= policy_scope(conversations.find(params[:conversation_id]))
  end
end
