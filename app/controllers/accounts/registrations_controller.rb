class Accounts::RegistrationsController < Devise::RegistrationsController
  include Accessible

  def new
    super do |account|
      account.build_organization
      account.build_person
    end
  end

  def create
    super { |account| Registrar.new(account).register }
  end

  private

  def sign_up_params
    params.require(resource_name).permit(attributes)
  end

  def attributes
    account_attributes
      .push(organization_attributes: organization_attributes_keys)
  end

  def after_sign_up_path_for(*)
    recruiting_ads_path
  end

  def account_attributes
    %i[email password agreed_to_terms phone_number name]
  end

  def organization_attributes_keys
    %i[name size].push(teams_attributes: teams_attributes)
  end

  def teams_attributes
    %i[name].push(location_attributes: location_attributes)
  end

  def location_attributes
    %i[full_street_address
       latitude
       longitude
       city
       state
       state_code
       postal_code
       country
       country_code]
  end

  def organization_attributes
    params[:account][:organization_attributes]
  end
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
