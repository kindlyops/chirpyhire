class Registrar
  def initialize(account, referrer = nil)
    @account = account
    @referrer = referrer
  end

  def register
    return unless account.persisted?
    account.update(person: Person.create)
    create_contact_stages
    setup_account
    setup_organization
    TeamRegistrar.call(team, account, notify: false)
    new_organization_notification_job
  end

  private

  attr_reader :account, :referrer

  delegate :location, :contact_stages, to: :organization

  def create_contact_stages
    contact_stages.create(name: 'Potential', rank: 1, editable: false)
    contact_stages.create(name: 'Scheduled', rank: 2, editable: false)
    contact_stages.create(name: 'No Show', rank: 3, editable: false)
    contact_stages.create(name: 'Not Now', rank: 4, editable: false)
    contact_stages.create(name: 'Hired', rank: 5, editable: false)
  end

  def trial_length
    14.days.from_now
  end

  def setup_account
    account.update(role: :owner)
    BotFactory::Maker.call(account)
  end

  def setup_organization
    organization.update(billing_email: account.email)
    organization.update(referrer: referrer) if referrer.present?
    organization.create_subscription(trial_ends_at: trial_length)
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
