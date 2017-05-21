class NotificationMailerPreview < ActionMailer::Preview
  def contact_ready_for_review
    NotificationMailer.contact_ready_for_review(Conversation.last)
  end

  def contact_waiting
    NotificationMailer.contact_waiting(Conversation.last)
  end

  def team_created
    NotificationMailer.team_created(Team.last, Account.last)
  end

  def added_to_team
    NotificationMailer.added_to_team(Membership.last)
  end
end
