class TeamRegistrar
  def self.call(team, account)
    new(team, account).call
  end

  def initialize(team, account)
    @team = team
    @account = account
  end

  attr_reader :team, :account
  delegate :organization, to: :team

  def call
    setup_account_on_team
    team.create_inbox
    provision_phone_number
    create_recruiting_ad

    NewTeamNotificationJob.perform_later(team)
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
