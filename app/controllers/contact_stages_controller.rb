class ContactStagesController < ApplicationController
  def index
    @contact_stages = policy_scope(ContactStage.unarchived).order(:rank)

    respond_to do |format|
      format.json
    end
  end
end
