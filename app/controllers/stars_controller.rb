class StarsController < ApplicationController
  def create
    contact.update(starred: !contact.starred)

    redirect_to inbox_conversation_path(current_inbox, conversation)
  end

  private

  def conversation
    @conversation ||= current_inbox.conversations.find_by(contact: contact)
  end

  def contact
    @contact ||= authorize Contact.find(params[:contact_id])
  end
end
