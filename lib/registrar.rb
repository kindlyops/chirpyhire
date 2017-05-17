class Registrar
  def initialize(account)
    @account = account
  end

  def register
    return unless account.persisted?

    provision_phone_number
    team.update(recruiter: account)
    team.accounts << account
    create_recruiting_ad
    new_organization_notification_job
  end

  private

  attr_reader :account

  def create_recruiting_ad
    team.create_recruiting_ad(body: RecruitingAd.body(team))
  end

  def provision_phone_number
    PhoneNumberProvisioner.provision(team)
  end

  def new_organization_notification_job
    NewOrganizationNotificationJob.perform_later(account)
  end

  def team
    @team ||= organization.teams.first
  end

  def organization
    @organization ||= account.organization
  end

  delegate :location, to: :team
end
