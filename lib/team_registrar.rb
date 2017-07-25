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
    phone_number = provision_phone_number
    create_recruiting_ad(phone_number)
    create_bot_campaign
    NewTeamNotificationJob.perform_later(team) if notify.present?
  end

  private

  def create_bot_campaign
    bot.bot_campaigns.create(inbox: team.inbox, campaign: campaign)
  end

  def campaign
    @campaign ||= organization.campaigns.find_or_create_by(name: name)
  end

  def bot
    @bot ||= organization.bots.first
  end

  def name
    "#{bot.name} on call: #{team.name}"
  end

  def setup_account_on_team
    team.accounts << account
  end

  def create_recruiting_ad(phone_number)
    team.create_recruiting_ad(
      body: RecruitingAd.body(team, phone_number), organization: organization
    )
  end

  def provision_phone_number
    PhoneNumberProvisioner.provision(team)
  end
end
