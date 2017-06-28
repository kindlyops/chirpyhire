class Settings::GeneralsController < ApplicationController
  before_action :fetch_organization, only: %i[show update]

  def show; end

  private

  def fetch_organization
    @organization ||= authorize(Organization.find(params[:organization_id]))
  end
end
