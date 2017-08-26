class DailyMailer < ApplicationMailer
  layout 'report'
  
  def slipping_away(account)
    @report = Report::SlippingAway.new(account)

    track user: @report.account
    mail(to: @report.account_email, subject: @report.subject)
  end

  def newly_added(account)
    @report = Report::NewlyAdded.new(account)

    track user: @report.account
    mail(to: @report.account_email, subject: @report.subject)
  end

  def active(account)
    @report = Report::Active.new(account)

    track user: @report.account
    mail(to: @report.account_email, subject: @report.subject)
  end

  def passive(account)
    @report = Report::Passive.new(account)

    track user: @report.account
    mail(to: @report.account_email, subject: @report.subject)
  end
end
