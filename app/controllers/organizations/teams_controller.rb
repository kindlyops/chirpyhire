class Organizations::TeamsController < OrganizationsController
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

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end

  def team_index_path
    organization_settings_teams_path(current_organization)
  end

  def create_notice
    "#{@team.name} created!"
  end
end
