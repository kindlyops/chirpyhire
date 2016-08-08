class Reporter

  def initialize(recipients, report_klass, period)
    @recipients = recipients
    @report_klass = report_klass
    @period = period
  end

  def report
    recipients.active.find_each do |recipient|
      ReportMailer.send(period, report_for(recipient)).deliver_now
    end
  end

  private

  def report_for(recipient)
    report_klass.new(recipient)
  end

  attr_reader :recipients, :report_klass, :period
end
