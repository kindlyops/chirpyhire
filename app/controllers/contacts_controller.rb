class ContactsController < ApplicationController
  decorates_assigned :contact

  def show
    @contact = authorize(Contact.find(params[:id]))

    respond_to do |format|
      format.json
    end
  end

  def update
    @contact = authorize(Contact.find(params[:id]))
    @contact.update(permitted_attributes(Contact))

    Broadcaster::Contact.broadcast(@contact)
    head :ok
  end
end
