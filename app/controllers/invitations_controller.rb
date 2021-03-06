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
      Internal::Notification::Account.call(account)
    end
  end

  def create
    super do |account|
      return handle_create_errors if account.errors.present?

      account.update(role: :invited)
      account.update(person: Person.create)

      account.memberships.find_or_create_by(team: team) unless teams.empty?
    end
  end

  private

  def team
    @team ||= teams.order(:id).first
  end

  delegate :organization, to: :current_inviter
  delegate :teams, to: :organization

  def handle_create_errors
    flash[:alert] = "Oops! The user's email is already taken."
    redirect_to organization_settings_team_members_path(organization)
  end

  def invite_params
    super.merge(organization: organization)
  end

  def after_invite_path_for(*)
    organization_settings_team_members_path(organization)
  end

  def add_accept_params
    devise_parameter_sanitizer.permit(
      :accept_invitation,
      keys: %i[agreed_to_terms name]
    )
  end

  def add_invite_params
    devise_parameter_sanitizer.permit(
      :invite,
      keys: [:name]
    )
  end

  def devise_mapping
    Devise.mappings[:account]
  end

  def authenticate_inviter!
    authenticate_account!(force: true) && current_account
  end
end
