class OrganizationsController < ApplicationController
  before_action :fetch_organization, only: [:show, :update]
  
  def show
  end

  def update
    if @organization.update(permitted_attributes(Organization))
      redirect_to organization_path(@organization), notice: update_notice
    else
      render :show
    end
  end

  private

  def fetch_organization
    @organization ||= authorize(Organization.find(params[:id]))
  end

  def update_notice
    'Organization updated!'
  end
end
