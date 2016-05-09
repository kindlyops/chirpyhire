class RegistrationsController < Devise::RegistrationsController
  def new
    build_resource({})
    user = self.resource.build_user
    user.build_organization
    set_minimum_password_length
    yield resource if block_given?
    respond_with self.resource
  end

  def create
    super { |account| account.role = "owner" }
  end

  private

  def sign_up_params
    allow = [:email, :password, :password_confirmation,
      [user_attributes: [:phone_number, :first_name, :last_name, organization_attributes: [:name]]]
    ]
    params.require(resource_name).permit(allow)
  end

  def after_sign_up_path_for(resource)
    new_invitation_path(resource)
  end
end
