class InvitationsController < Devise::InvitationsController
  before_action :add_user_params, only: :update

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

  def after_invite_path_for(inviter)
    survey_path(inviter.survey)
  end

  def organization
    current_inviter.organization
  end

  def add_user_params
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:agreed_to_terms, user_attributes: [:name]])
  end
end
