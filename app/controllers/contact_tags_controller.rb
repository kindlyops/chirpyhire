class ContactTagsController < ApplicationController
  def index
    @tags = policy_scope(Tag).order(:name)

    respond_to do |format|
      format.json
    end
  end
end
