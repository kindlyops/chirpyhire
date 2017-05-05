class NotificationMailer < ApplicationMailer
  def contact_ready_for_review(conversation)
    @conversation = conversation

    track user: conversation.account
    subject = 'Your new caregiver wants to chat 🌟'
    mail(to: conversation.account.email, subject: subject)
  end

  def contact_waiting(conversation)
    @conversation = conversation

    track user: conversation.account
    subject = 'Hurry! Your caregiver is slipping away... ⏰'
    mail(to: conversation.account.email, subject: subject)
  end
end
