class InternalMailer < ApplicationMailer
  def health(filename)
    attachments["health-#{Date.current.to_i}.csv"] = File.read(filename)
    mail(to: 'harry@chirpyhire.com', subject: 'ChirpyHire: Health Report')
  end
end
