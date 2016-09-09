class Payment::Mailer::Subscriptions < ActionMailer::Base
  default from: "Harry Whelchel <harry@chirpyhire.com>"

  def deleted(subscription)
    @subscription = subscription
    mail(to: "team@chirpyhire.com", subject: "Bumskis. Subscription canceled.")
  end
end
