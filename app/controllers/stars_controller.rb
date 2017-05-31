class StarsController < ApplicationController
  def create
    contact.update(starred: !contact.starred)

    redirect_to inbox_conversation_path(inbox, conversation)
  end

  private

  def inbox
    @inbox ||= current_inbox
  end

  def conversation
    @conversation ||= inbox.conversations.find_by(contact: contact)
  end

  def contact
    @contact ||= authorize Contact.find(params[:contact_id])
  end
end
