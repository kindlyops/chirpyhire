class Settings::PasswordsController < Accounts::RegistrationsController
  prepend_before_action :set_minimum_password_length, only: :show

  def show
    self.resource = authorize(current_account)
  end

  def update
    self.resource = authorize(current_account)

    resource_updated = update_resource(resource, account_update_params)

    if resource_updated
      bypass_sign_in resource, scope: resource_name
      redirect_to account_password_path, notice: 'Password updated!'
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :show
    end
  end

  private

  def account_password_path
    account_settings_password_path(resource)
  end

  def devise_mapping
    Devise.mappings[:account]
  end
end
