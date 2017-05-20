class NewTeamNotificationJob < ApplicationJob
  def perform(team)
    @team = team
    @organization = team.organization

    notifier.ping new_team_message if Rails.env.production?
  end

  def notifier
    @notifier ||= Slack::Notifier.new(
      ENV.fetch('SLACK_WEBHOOK'), channel: '#general', username: 'freddy'
    )
  end

  def new_team_message
    <<~MESSAGE
      New Team Created!

      Organization: #{organization.name}
      Team Name: #{team.name}
    MESSAGE
  end

  attr_reader :team, :organization
end
