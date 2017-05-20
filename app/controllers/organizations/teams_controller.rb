class Organizations::TeamsController < OrganizationsController
  def index
    @teams = policy_scope(organization.teams)
  end

  def show
    @team = authorize(Team.find(params[:id]))
  end

  def update
    @team = authorize(Team.find(params[:id]))
    if @team.update(permitted_attributes(Team))
      redirect_to team_path, notice: update_notice
    else
      render :show
    end
  end

  private

  def fetch_organization
    @organization ||= authorize(Organization.find(params[:organization_id]))
  end

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end

  def team_path
    organizations_team_path(current_organization, @team)
  end

  def update_notice
    'Team updated!'
  end
end
