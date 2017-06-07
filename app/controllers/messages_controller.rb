class MessagesController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index
  decorates_assigned :conversation

  def index
    redirect_to conversations_path
  end

  def show
    @conversation = authorize fetch_conversation, :show?

    redirect_to conversation_path
  end

  private

  def conversations_path
    inbox_conversations_path(current_inbox)
  end

  def conversation_path
    inbox_conversation_path(current_inbox, @conversation)
  end

  def fetch_conversation
    contact.conversations.first
  end

  def contact
    @contact ||= Contact.find(params[:contact_id])
  end
end
