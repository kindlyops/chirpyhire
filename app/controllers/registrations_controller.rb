# frozen_string_literal: true
class RegistrationsController < Devise::RegistrationsController
  before_action :fetch_address, only: :create

  def new
    build_resource({})
    organization = user.build_organization
    organization.build_location
    set_minimum_password_length
    yield resource if block_given?
    respond_with resource
  end

  def create
    super { |account| Registrar.new(account).register }
  end

  private

  def user
    resource.build_user
  end

  def sign_up_params
    allow = [:email, :password, :password_confirmation, :agreed_to_terms,
             [user_attributes: [:phone_number, :name,
                                organization_attributes: [:name,
                                                          location_attributes: [:full_street_address, :latitude, :longitude, :city, :state, :state_code, :postal_code, :country, :country_code]]]]]
    params.require(resource_name).permit(allow)
  end

  def after_sign_up_path_for(resource)
    new_invitation_path(resource)
  end

  def fetch_address
    build_resource(sign_up_params)

    finder = AddressFinder.new(location_params[:full_street_address])
    if finder.found?
      %i(full_street_address latitude longitude city state state_code postal_code country country_code).each do |field|
        location_params[field] = finder.send(field)
      end
    else
      flash[:alert] = "We couldn't find that address. Please provide the city, state, and zipcode if you haven't yet."
      render :new
    end
  rescue Geocoder::OverQueryLimitError
    Rollbar.debug($ERROR_INFO.message)
    flash[:alert] = "Sorry but we're a little overloaded right now and can't find addresses. Please try again in a few minutes."
    render :new
  end

  def location_params
    params[:account][:user_attributes][:organization_attributes][:location_attributes]
  end
end
