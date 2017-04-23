class NotesController < ApplicationController
  skip_after_action :verify_policy_scoped
  layout 'messages', only: 'index'
  decorates_assigned :conversation

  def index
    @conversation = authorize fetch_conversation, :show?
  end

  private

  def fetch_conversation
    current_account.conversations.find_by(contact: contact)
  end

  def contact
    @contact ||= Contact.find(params[:message_contact_id])
  end
end
