class InvitationsController < Devise::InvitationsController
  before_action :add_accept_params, only: :update
  before_action :add_invite_params, only: :create

  def new
    self.resource = resource_class.new
    resource.build_person
    render :new
  end

  def edit
    set_minimum_password_length
    resource.invitation_token = params[:invitation_token]
    render :edit
  end

  def update
    super do |account|
      account.update(role: :member) if account.invited?
    end
  end

  def create
    super do |account|
      account.update(role: :invited)
      account.teams << TeamFindOrCreator.call(organization)
      GlacierBreakerJob.perform_later(account)
    end
  end

  private

  delegate :organization, to: :current_inviter

  def invite_params
    super.merge(organization: organization)
  end

  def after_invite_path_for(*)
    new_account_invitation_path
  end

  def add_accept_params
    devise_parameter_sanitizer.permit(
      :accept_invitation,
      keys: [:agreed_to_terms, :email, person_attributes: %i(name)]
    )
  end

  def add_invite_params
    devise_parameter_sanitizer.permit(
      :invite,
      keys: [:email, person_attributes: %i(name)]
    )
  end

  def devise_mapping
    Devise.mappings[:account]
  end
end
