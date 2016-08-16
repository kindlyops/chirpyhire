class Payment::Mailer::Charges < ActionMailer::Base
  default from: "Harry Whelchel <harry@chirpyhire.com>"

  def succeeded(charge)
    @charge = charge
    mail(to: "harry@chirpyhire.com", subject: "Dolla dolla bills y'all.")
  end

  def failed(charge)
    @charge = charge
    mail(to: "harry@chirpyhire.com", subject: "Ahh hell nah. Charge failed.")
  end

end
