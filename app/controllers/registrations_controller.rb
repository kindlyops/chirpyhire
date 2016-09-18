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
    allow = account_attributes.push([user_attributes: user_attributes])

    params.require(resource_name).permit(allow)
  end

  def after_sign_up_path_for(resource)
    new_invitation_path(resource)
  end

  def fetch_address
    with_rate_limit_protection do
      build_resource(sign_up_params)

      if finder.found?
        populate_location_attributes
      else
        flash[:alert] = "We couldn't find that address. Please provide the"\
        " city, state, and zipcode if you haven't yet."
        render :new
      end
    end
  end

  def finder
    @finder ||= AddressFinder.new(location_attributes[:full_street_address])
  end

  def with_rate_limit_protection
    yield
  rescue Geocoder::OverQueryLimitError => e
    Rollbar.debug(e.message)
    flash[:alert] = "Sorry but we're a little overloaded right now and can't "\
    'find addresses. Please try again in a few minutes.'

    render :new
  end

  def populate_location_attributes
    location_attribute_keys.each do |field|
      location_attributes[field] = finder.send(field)
    end
  end

  def location_attributes
    organization_attributes[:location_attributes]
  end

  def organization_attributes
    params[:account][:user_attributes][:organization_attributes]
  end

  def user_attributes
    [:phone_number, :name, organization_attributes: organization_attribute_keys]
  end

  def organization_attribute_keys
    [:name, location_attributes: location_attribute_keys]
  end

  def account_attributes
    %i(email password password_confirmation agreed_to_terms)
  end

  def location_attribute_keys
    %i(full_street_address
       latitude
       longitude
       city
       state
       state_code
       postal_code
       country
       country_code)
  end
end
