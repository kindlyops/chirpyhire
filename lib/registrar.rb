class Registrar
  def initialize(account)
    @account = account
  end

  def register
    return unless account.persisted?
    account.update(person: Person.create)
    create_contact_stages
    setup_account
    organization.create_subscription(trial_ends_at: trial_length)
    TeamRegistrar.call(team, account, notify: false)
    new_organization_notification_job
  end

  private

  attr_reader :account

  delegate :location, to: :organization

  def create_contact_stages
    organization.contact_stages.create(name: 'New', rank: 1)
    organization.contact_stages.create(name: 'Screened', rank: 2)
    organization.contact_stages.create(name: 'Not Now', rank: 3)
    organization.contact_stages.create(name: 'Scheduled', rank: 4)
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
