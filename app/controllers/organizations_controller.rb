class OrganizationsController < ApplicationController
  before_action :fetch_organization, only: %i[show update]

  def show; end

  def update
    if @organization.update(permitted_attributes(Organization))
      current_account.organization.reload
      Broadcaster::Account.broadcast(current_account)

      respond_to do |format|
        format.html { redirect_to_organization }
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.html { render :show }
        format.json { head :unprocessable_entity }
      end
    end
  end

  private

  def fetch_organization
    @organization ||= authorize(Organization.find(params[:id]))
  end

  def update_notice
    "#{@organization.name} updated!"
  end

  def redirect_to_organization
    redirect_to organization_path(@organization), notice: update_notice
  end
end
