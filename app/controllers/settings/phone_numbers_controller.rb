class Settings::PhoneNumbersController < ApplicationController
  def index
    @phone_numbers = policy_scope(organization.phone_numbers)
  end

  private

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end
end
