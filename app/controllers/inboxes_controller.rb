class InboxesController < ApplicationController
  decorates_assigned :inbox

  def show
    @inbox = authorize(Inbox.find(params[:id]))

    respond_to do |format|
      format.json
    end
  end
end
