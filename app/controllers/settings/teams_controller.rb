class Settings::TeamsController < ApplicationController
  def index
    @teams = policy_scope(organization.teams)
  end

  private

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end
end
