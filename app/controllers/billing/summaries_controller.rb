class Billing::SummariesController < ApplicationController
  def show
    @organization = authorize(organization)
  end

  private

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end
end
