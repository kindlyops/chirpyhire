class ReportMailer < ActionMailer::Base
  default from: 'Harry Whelchel <harry@chirpyhire.com>',
          bcc: 'team@chirpyhire.com'

  def send_report(report)
    if report.send?
      @report = report
      mail(
        to: report.recipient_email,
        subject: report.subject,
        template_name: report.template_name
      )
    end
  end
end
