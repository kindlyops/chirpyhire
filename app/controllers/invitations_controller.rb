class InvitationsController < Devise::InvitationsController
  before_action :add_account_params, only: :update

  def edit
    set_minimum_password_length
    resource.invitation_token = params[:invitation_token]
    render :edit
  end

  private

  delegate :organization, to: :current_inviter

  def invite_params
    super.merge(organization: organization)
  end

  def after_invite_path_for(*)
    organizations_settings_people_invitation_new_path
  end

  def add_account_params
    devise_parameter_sanitizer.permit(
      :accept_invitation,
      keys: [:agreed_to_terms, :email]
    )
  end

  def devise_mapping
    Devise.mappings[:account]
  end
end
