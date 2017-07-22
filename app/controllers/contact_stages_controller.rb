class ContactStagesController < ApplicationController
  def index
    @contact_stages = policy_scope(ContactStage).order(:rank)

    respond_to do |format|
      format.json
    end
  end
end
