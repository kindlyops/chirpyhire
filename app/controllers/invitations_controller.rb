class InvitationsController < Devise::InvitationsController
  before_filter :add_user_params, only: :update

  def edit
    set_minimum_password_length if respond_to? :set_minimum_password_length
    resource.invitation_token = params[:invitation_token]
    resource.user
    render :edit
  end

  private

  def invite_resource(&block)
    organization.accounts.invite!(invite_params, current_inviter, &block)
  end

  def invite_params
    super.merge(user_attributes: { organization: organization })
  end

  def organization
    current_inviter.organization
  end

  def add_user_params
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [user_attributes: [:first_name, :last_name]])
  end
end
