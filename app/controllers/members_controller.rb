class MembersController < ApplicationController
  def create
    @member = authorize new_member

    if @member.save
      notify_team_member
      redirect_to member_index_path
    else
      render :index
    end
  end

  def destroy
    @member = authorized_member
    @member.destroy

    redirect_to member_index_path
  end

  private

  def notify_team_member
    TeamMemberNotifier.call(@member)
  end

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
    organization_teams_path(organization)
  end
end
