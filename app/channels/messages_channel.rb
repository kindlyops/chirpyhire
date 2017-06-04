class MessagesChannel < ApplicationCable::Channel
  def subscribed
    reject if conversation.blank?
    stream_for conversation
  end

  delegate :conversations, to: :current_account

  private

  def conversation
    @conversation ||= begin
      authorize(conversations.find(params[:conversation_id]), :show?)
    end
  end
end
