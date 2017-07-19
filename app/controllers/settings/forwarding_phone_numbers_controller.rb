class Settings::ForwardingPhoneNumbersController < ApplicationController
  def update
    if organization.update(permitted_attributes(Organization))
      update_unset_phone_numbers
      redirect_to phone_number_settings, notice: success_notice
    else
      @phone_numbers = policy_scope(organization.phone_numbers)
      render 'settings/phone_numbers/index'
    end
  end

  private

  def update_unset_phone_numbers
    organization.phone_numbers.not_forwarding.find_each do |phone_number|
      phone_number.update(
        forwarding_phone_number: organization.forwarding_phone_number
      )
    end
  end

  def phone_number_settings
    organization_settings_phone_numbers_path(organization)
  end

  def success_notice
    "Forwarding all calls to #{forwarding_phone_number}"
  end

  def forwarding_phone_number
    organization.forwarding_phone_number.phony_formatted
  end

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end
end
