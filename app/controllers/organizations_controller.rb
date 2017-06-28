class OrganizationsController < ApplicationController
  before_action :fetch_organization, only: %i[update]

  def update
    if @organization.update(permitted_attributes(Organization))
      success_response
    else
      error_response
    end
  end

  private

  def success_response
    Broadcaster::Organization.broadcast(@organization)

    respond_to do |format|
      format.html { redirect_to_organization }
      format.json { head :ok }
    end
  end

  def error_response
    respond_to do |format|
      format.html { render :show }
      format.json { head :unprocessable_entity }
    end
  end

  def fetch_organization
    @organization ||= authorize(Organization.find(params[:id]))
  end

  def update_notice
    "#{@organization.name} updated!"
  end

  def redirect_to_organization
    redirect_to settings_path, notice: update_notice
  end

  def settings_path
    organization_settings_general_path(@organization)
  end
end
