class Registrar
  def initialize(account)
    @account = account
  end

  def register
    return unless account.persisted?
    setup_account
    TeamRegistrar.call(team, account, notify: false)
    new_organization_notification_job
  end

  private

  attr_reader :account

  delegate :location, to: :organization

  def setup_account
    account.update(role: :owner)
    BotMaker::DefaultBot.call(organization)
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
