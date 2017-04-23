class NotesController < ApplicationController
  layout 'messages', only: 'index'
  decorates_assigned :conversation

  def index
    @conversation = authorize fetch_conversation, :show?
    @notes = policy_scope(contact.notes)
  end

  private

  def fetch_conversation
    current_account.conversations.find_by(contact: contact)
  end

  def contact
    @contact ||= Contact.find(params[:message_contact_id])
  end
end
