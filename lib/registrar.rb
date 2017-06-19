class Registrar
  def initialize(account)
    @account = account
  end

  def register
    return unless account.persisted?
    TeamRegistrar.call(team, account, notify: false)
    setup_account
    create_ideal_candidate
    new_organization_notification_job
  end

  private

  attr_reader :account

  delegate :location, to: :organization

  def setup_account
    account.update(role: :owner)
  end

  def create_ideal_candidate
    organization.create_ideal_candidate!(
      zipcodes_attributes: [{ value: team.zipcode }]
    )
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
