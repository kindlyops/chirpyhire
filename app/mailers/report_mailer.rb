class ReportMailer < ActionMailer::Base
  default from: 'Harry Whelchel <harry@chirpyhire.com>',
          bcc: 'team@chirpyhire.com'

  def daily(report)
    unless report.qualified_count.positive? && !report.organization.inactive?
      return
    end

    @report = report
    mail(to: report.recipient_email, subject: report.subject)
  end

  def weekly(report)
    return unless !report.organization.inactive?

    @report = report
    mail(to: report.recipient_email, subject: report.subject)
  end
end
