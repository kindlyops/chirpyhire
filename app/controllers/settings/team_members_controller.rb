class Settings::TeamMembersController < ApplicationController
  def index
    @accounts = policy_scope(organization.accounts)
  end

  private

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end
end
