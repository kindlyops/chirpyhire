class ContactsController < ApplicationController
  def index
    @contacts = policy_scope(Contact)
  end

  def update
    @contact = authorized_contact
    @contact.update(permitted_attributes(Contact))

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def authorized_contact
    authorize Contact.find(params[:id])
  end
end
