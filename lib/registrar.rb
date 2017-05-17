class Registrar
  def initialize(account)
    @account = account
  end

  def register
    return unless account.persisted?
    organization.update(recruiter: account)
    create_ideal_candidate
    provision_phone_number
    create_recruiting_ad
    TeamCreator.call(organization)
    new_organization_notification_job
  end

  private

  attr_reader :account

  def create_ideal_candidate
    organization.create_ideal_candidate!(
      zipcodes_attributes: [{ value: organization.zipcode }]
    )
  end

  delegate :location, to: :organization

  def create_recruiting_ad
    organization.create_recruiting_ad(body: RecruitingAd.body(organization))
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
