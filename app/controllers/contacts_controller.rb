class ContactsController < ApplicationController
  decorates_assigned :contact

  def show
    @contact = authorize(Contact.find(params[:id]))

    respond_to do |format|
      format.json
    end
  end
end
