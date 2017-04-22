class NotesController < ApplicationController
  skip_after_action :verify_policy_scoped
  layout 'messages', only: 'index'

  def index
    conversation
  end

  private

  def conversation
    @conversation ||= authorize fetch_conversation, :show?
  end

  def fetch_conversation
    current_account.conversations.find_by(contact: contact)
  end

  def contact
    @contact ||= Contact.find(params[:message_contact_id])
  end
end
