class RegistrationsController < Devise::RegistrationsController
  def new
    build_resource({})
    self.resource.build_user
    self.resource.build_organization
    set_minimum_password_length
    yield resource if block_given?
    respond_with self.resource
  end

  def create
    super { |account| account.owner! }
  end

  private

  def sign_up_params
    allow = [:email, :password, :password_confirmation,
      [user_attributes: [:phone_number, :first_name, :last_name]],
      [organization_attributes: [:name]]
    ]
    sign_up_params = params.require(resource_name).permit(allow)
    sign_up_params[:organization_attributes][:industry_id] = home_care.id
    sign_up_params
  end

  def after_sign_up_path_for(resource)
    new_invitation_path(resource)
  end

  def home_care
    Industry.find_or_create_by(name: "Home Care")
  end
end
