class Settings::PhoneNumbersController < ApplicationController
  def index
    @phone_numbers = policy_scope(organization.phone_numbers)
  end

  def update
    if phone_number.update(permitted_attributes(PhoneNumber))
      redirect_to phone_number_settings, notice: success_notice
    else
      render :index
    end
  end

  private

  def phone_number_settings
    organization_settings_phone_numbers_path(organization)
  end

  def success_notice
    "Forwarding calls to #{format_phone_number} to #{forwarding_phone_number}"
  end

  def forwarding_phone_number
    phone_number.forwarding_phone_number.phony_formatted
  end

  def format_phone_number
    phone_number.phone_number.phony_formatted
  end

  def phone_number
    @phone_number ||= authorize(phone_numbers.find(params[:id]))
  end

  def phone_numbers
    @phone_numbers ||= policy_scope(organization.phone_numbers)
  end

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end
end
