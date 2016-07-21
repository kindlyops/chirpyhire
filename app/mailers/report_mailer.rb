class ReportMailer < ActionMailer::Base
  default from: "Harry Whelchel <harry@chirpyhire.com>", bcc: "harry@chirpyhire.com"

  def daily(report)
    @report = report
    mail(to: report.recipient_email, subject: report.subject)
  end

end
