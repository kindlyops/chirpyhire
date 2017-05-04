class NotificationMailer < ApplicationMailer
  def contact_ready_for_review(conversation)
    @conversation = conversation

    mail(to: conversation.account.email)
  end

  def contact_waiting(conversation)
    @conversation = conversation

    mail(to: conversation.account.email)
  end
end
