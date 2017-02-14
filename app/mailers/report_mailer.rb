class ReportMailer < ActionMailer::Base
  default from: 'Harry Whelchel <harry@chirpyhire.com>',
          bcc: 'team@chirpyhire.com'

  def send_report(report)
    mail_report if report.send?
  end

  private

  def mail_report
    @report = report
    mail(
      to: report.recipient_email,
      subject: report.subject,
      template_name: report.template_name
    )
  end
end
