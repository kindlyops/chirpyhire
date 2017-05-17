class Registrar
  def initialize(account)
    @account = account
  end

  def register
    return unless account.persisted?
    organization.update(recruiter: account)
    create_ideal_candidate
    provision_phone_number
    setup_team
    new_organization_notification_job
  end

  private

  attr_reader :account

  def create_ideal_candidate
    organization.create_ideal_candidate!(
      zipcodes_attributes: [{ value: organization.zipcode }]
    )
  end

  def team
    @team ||= begin
      organization.teams.create(
        phone_number: organization.phone_number,
        name: location.city,
        recruiter: account
      )
    end
  end

  def setup_team
    location.update(team: team)
    recruiting_ad.update(team: team)
    team.accounts << account
  end

  delegate :location, to: :organization

  def recruiting_ad
    @recruiting_ad ||= begin
      organization.create_recruiting_ad(body: RecruitingAd.body(organization))
    end
  end

  def provision_phone_number
    PhoneNumberProvisioner.provision(organization)
  end

  def new_organization_notification_job
    NewOrganizationNotificationJob.perform_later(account)
  end

  def organization
    @organization ||= account.organization
  end
end
