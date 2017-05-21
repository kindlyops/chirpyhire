class NewTeamNotificationJob < ApplicationJob
  def perform(team)
    NewTeamNotification.call(team)
  end
end
