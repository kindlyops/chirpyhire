class CurrentOrganizationController < ApplicationController
  def show
    @organization = authorize(current_organization)

    respond_to do |format|
      format.json
    end
  end
end
