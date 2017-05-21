class MembersController < ApplicationController
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

  def new
    @accounts = non_member_accounts
    @member = authorize team.memberships.build
  end

  def create
    @member = authorize new_member

    if @member.save
      notify_team_member
      redirect_to member_new_path, notice: create_notice
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

  def notify_team_member
    TeamMemberNotifier.call(@member)
  end

  def non_member_accounts
    current_organization.accounts.where.not(id: team.accounts.pluck(:id))
  end

  def member_new_path
    new_organization_team_member_path(organization, team)
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
    organization_team_members_path(organization, team)
  end

  def update_notice
    "#{@member.account.name} team role updated!"
  end

  def create_notice
    "#{@member.account.name} added to #{@member.team.name}!"
  end

  def destroy_notice
    "#{@member.account.name} removed from #{@member.team.name}!"
  end
end
