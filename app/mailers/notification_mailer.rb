class NotificationMailer < ApplicationMailer
  def caregiver_ready_for_review(account, contact)
    @contact = contact

    mail(to: account.email)
  end
end
