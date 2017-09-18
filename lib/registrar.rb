class Registrar
  def initialize(account)
    @account = account
  end

  def register
    return unless account.persisted?
    account.update(person: Person.create)
    create_contact_stages
    setup_account
    organization.update(billing_email: account.email)
    organization.create_subscription(trial_ends_at: trial_length)
    TeamRegistrar.call(team, account, notify: false)
    new_organization_notification_job
  end

  private

  attr_reader :account

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
