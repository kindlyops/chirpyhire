class RegistrationsController < Devise::RegistrationsController
  def new
    super(&:build_organization)
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

  def after_sign_up_path_for(*)
    candidate_path
  end

  def account_attributes
    %i(email password agreed_to_terms)
  end

  def organization_attributes
    %i(name zip_code)
  end
end
