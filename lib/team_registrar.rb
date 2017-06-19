class TeamRegistrar
  def self.call(team, account, notify: true)
    new(team, account, notify: notify).call
  end

  def initialize(team, account, notify: true)
    @team = team
    @account = account
    @notify = notify
  end

  attr_reader :team, :account, :notify
  delegate :organization, to: :team

  def call
    setup_account_on_team
    team.create_inbox
    provision_phone_number
    create_recruiting_ad

    NewTeamNotificationJob.perform_later(team) if notify.present?
  end

  private

  def setup_account_on_team
    team.accounts << account
    team.promote(account)
    team.update(recruiter: account)
  end

  def create_recruiting_ad
    team.create_recruiting_ad(
      body: RecruitingAd.body(team), organization: organization
    )
  end

  def provision_phone_number
    PhoneNumberProvisioner.provision(team)
  end
end
