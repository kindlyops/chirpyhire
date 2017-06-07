class StarsController < ApplicationController
  def create
    contact.update(starred: !contact.starred)
    Broadcaster::Contact.broadcast(contact)
    head :ok
  end

  private

  def contact
    @contact ||= authorize Contact.find(params[:contact_id])
  end
end
