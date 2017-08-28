class InternalMailer < ApplicationMailer
  def health
    filename = "health-#{DateTime.current.to_i}.csv"
    attachments[filename] = Internal::Report::Health.call
    mail(to: 'harry@chirpyhire.com', subject: 'ChirpyHire: Health Report')
  end
end
