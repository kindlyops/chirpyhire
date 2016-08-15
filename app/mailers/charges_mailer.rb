class ChargesMailer < ActionMailer::Base
  default from: "Harry Whelchel <harry@chirpyhire.com>", bcc: "harry@chirpyhire.com"

  def succeeded(charge)
    @charge = charge
    mail(to: "team@chirpyhire.com", subject: "Dolla dolla bills y'all.")
  end

  def failed(charge)
    @charge = charge
    mail(to: "team@chirpyhire.com", subject: "Ahh hell nah. Charge failed.")
  end

end
