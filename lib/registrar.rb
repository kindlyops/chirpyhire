class Registrar
  def initialize(account)
    @account = account
  end

  def register
    return unless account.persisted?
    create_recruiter
    create_ideal_candidate
    provision_phone_number
    create_recruiting_ad
    team.accounts << account
    new_organization_notification_job
  end

  private

  attr_reader :account

  delegate :location, to: :organization

  def create_ideal_candidate
    organization.create_ideal_candidate!(
      zipcodes_attributes: [{ value: team.zipcode }]
    )
  end

  def create_recruiter
    organization.update(recruiter: account)
    team.update(recruiter: account)
  end

  def create_recruiting_ad
    team.create_recruiting_ad(
      body: RecruitingAd.body(team), organization: organization
    )
  end

  def provision_phone_number
    PhoneNumberProvisioner.provision(team, organization)
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
end
