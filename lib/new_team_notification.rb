class NewTeamNotification
  def self.call(team)
    new(team).call
  end

  def initialize(team)
    @team = team
  end

  attr_reader :team

  def call
    send_email_notifications

    notifier.ping new_team_message if Rails.env.production?
  end

  private

  def notifier
    @notifier ||= Slack::Notifier.new(
      ENV.fetch('SLACK_WEBHOOK'), channel: '#metric', username: 'freddy'
    )
  end

  def send_email_notifications
    organization.owners.find_each do |owner|
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
