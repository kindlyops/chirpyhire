class Organizations::AccountsController < OrganizationsController
  def show
    @account = authorize Account.find(params[:id])
  end

  def update
    @account = authorize Account.find(params[:id])

    if @account.update(permitted_attributes(Account))
      redirect_to team_members_path, notice: update_notice
    else
      redirect_to team_members_path
    end
  end

  private

  def team_members_path
    organization_settings_team_members_path(@organization)
  end

  def fetch_organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end

  def update_notice
    "#{@account.name} updated!"
  end
end
