class DailyReporter

  def initialize(recipients)
    @recipients = recipients
  end

  def report
    recipients.find_each do |recipient|
      ReportMailer.daily(daily_report(recipient)).deliver_now
    end
  end

  private

  def daily_report(recipient)
    Report::Daily.new(recipient)
  end

  attr_reader :recipients
end
