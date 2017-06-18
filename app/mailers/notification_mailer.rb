class NotificationMailer < ApplicationMailer
  def contact_ready_for_review(inbox_conversation)
    @inbox_conversation = inbox_conversation
    @inboxable = inbox_conversation.inbox.inboxable
    return unless @inboxable.is_a?(Account)

    track user: @inboxable
    subject = 'Your new caregiver wants to chat 🌟'
    mail(to: @inboxable.email, subject: subject)
  end

  def contact_waiting(inbox_conversation)
    @inbox_conversation = inbox_conversation
    @inboxable = inbox_conversation.inbox.inboxable
    return unless @inboxable.is_a?(Account)

    track user: @inboxable
    subject = 'Hurry! Your caregiver is slipping away... ⏰'
    mail(to: @inboxable.email, subject: subject)
  end

  def team_created(team, owner)
    @team = team
    @owner = owner

    track user: owner
    subject = 'New team ready for lift-off! 🚀'
    mail(to: owner.email, subject: subject)
  end

  def added_to_team(membership)
    @account = membership.account
    @team = membership.team

    track user: @account
    subject = 'Hop on board your new team! 🚂'
    mail(to: @account.email, subject: subject)
  end
end
