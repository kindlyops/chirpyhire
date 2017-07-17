class Registrar
  def initialize(account)
    @account = account
  end

  def register
    return unless account.persisted?
    setup_account
    organization.create_subscription(trial_ends_at: trial_length)
    TeamRegistrar.call(team, account, notify: false)
    new_organization_notification_job
  end

  private

  attr_reader :account

  delegate :location, to: :organization

  def trial_length
    14.days.from_now
  end

  def setup_account
    account.update(role: :owner)
    BotFactory::Maker.call(organization)
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
