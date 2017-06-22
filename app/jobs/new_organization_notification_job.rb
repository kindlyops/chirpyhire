class NewOrganizationNotificationJob < ApplicationJob
  def perform(account)
    @account = account
    @organization = account.organization

    notifier.ping new_team_message if Rails.env.production?
  end

  def notifier
    @notifier ||= Slack::Notifier.new(
      ENV.fetch('SLACK_WEBHOOK'), channel: '#metric', username: 'freddy'
    )
  end

  def new_team_message
    <<~MESSAGE
      New Organization Signed Up!

      Organization: #{organization.name}
      Owner Name: #{account.name}
      Owner Email: #{account.email}
    MESSAGE
  end

  attr_reader :account, :organization
end
