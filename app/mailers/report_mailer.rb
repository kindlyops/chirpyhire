class ReportMailer < ActionMailer::Base
  default from: "harry@chirpyhire.com", bcc: "harry@chirpyhire.com"

  def daily(report)
    mail(to: report.recipient_email, subject: report.subject)
  end

end
