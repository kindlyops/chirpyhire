class RegistrationsController < Devise::RegistrationsController

  def new
    super do |account|
      account.build_organization
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
    account_attributes.push(organization_attributes: organization_attributes)
  end

  def after_sign_up_path_for(resource)
    new_invitation_path(resource)
  end

  def account_attributes
    %i(email password agreed_to_terms)
  end

  def organization_attributes
    %i(name zip_code)
  end
end
