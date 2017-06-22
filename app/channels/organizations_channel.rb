class OrganizationsChannel < ApplicationCable::Channel
  def subscribed
    reject if organization.blank?
    stream_for organization
  end

  private

  def organization
    @organization ||= authorize(Organization.find(params[:id]), :show?)
  end
end
