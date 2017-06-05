class StarsController < ApplicationController
  def create
    contact.update(starred: !contact.starred)
    Broadcaster::Contact.broadcast(contact)
    head :ok
  end

  private

  def conversation
    @conversation ||= current_inbox.conversations.find_by(contact: contact)
  end

  def contact
    @contact ||= authorize Contact.find(params[:contact_id])
  end
end
