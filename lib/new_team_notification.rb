class NewTeamNotification
  def self.call(team, account)
    new(team, account).call
  end

  def initialize(team, account)
    @team = team
    @account = account
  end

  attr_reader :team, :account

  def call
    send_email_notifications

    notifier.ping new_team_message if Rails.env.production?
  end

  private

  def notifier
    @notifier ||= Slack::Notifier.new(
      ENV.fetch('SLACK_WEBHOOK'), channel: '#general', username: 'freddy'
    )
  end

  def send_email_notifications
    organization.owners.where.not(id: account.id).find_each do |owner|
      NotificationMailer.team_created(team, owner).deliver_later
    end
  end

  def new_team_message
    <<~MESSAGE
      New Team Created!

      Organization: #{organization.name}
      Team Name: #{team.name}
    MESSAGE
  end

  attr_reader :team
  delegate :organization, to: :team
end
