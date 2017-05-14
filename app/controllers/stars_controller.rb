class StarsController < ApplicationController
  def create
    contact.update(starred: !contact.starred)

    redirect_to message_path(contact)
  end

  def contact
    @contact ||= authorize Contact.find(params[:contact_id])
  end
end
