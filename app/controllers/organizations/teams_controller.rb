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

  def create
    @team = authorize new_team

    if @team.save
      TeamRegistrar.call(@team, current_account)
      redirect_to team_index_path, notice: create_notice
    else
      render :new
    end
  end

  def new
    @team = authorize organization.teams.build
  end

  private

  def new_team
    organization.teams.build(permitted_attributes(Team))
  end

  def fetch_organization
    @organization ||= authorize(Organization.find(params[:organization_id]))
  end

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end

  def team_index_path
    organization_teams_path(current_organization)
  end

  def team_path
    organization_team_path(current_organization, @team)
  end

  def update_notice
    'Team updated!'
  end

  def create_notice
    'Team created!'
  end
end
