class MembersController < OrganizationsController
  def index
    @members = policy_scope(team.memberships)
  end

  def update
    @member = authorized_member

    if authorized_member.update(permitted_attributes(Membership))
      redirect_to member_index_path, notice: update_notice
    else
      render :index
    end
  end

  def create
    @member = authorize new_member

    if @member.save
      redirect_to member_index_path, notice: create_notice
    else
      render :index
    end
  end

  def destroy
    @member = authorized_member
    @member.destroy

    redirect_to member_index_path, notice: destroy_notice
  end

  private

  def authorized_member
    authorize Membership.find(params[:id])
  end

  def new_member
    team.memberships.build(permitted_attributes(Membership))
  end

  def team
    @team ||= authorize(organization.teams.find(params[:team_id]), :show?)
  end

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end

  def member_index_path
    organization_team_members_path(organization, team)
  end

  def update_notice
    "#{@member.account.name} role updated!"
  end

  def create_notice
    "#{@member.account.name} joined #{@member.team.name}!"
  end

  def destroy_notice
    "#{@member.account.name} left #{@member.team.name}!"
  end
end
