class NewTeamNotificationJob < ApplicationJob
  def perform(team, account)
    NewTeamNotification.call(team, account)
  end
end
