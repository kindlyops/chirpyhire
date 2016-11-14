class Reporter
  def initialize(recipients, report_klass)
    @recipients = recipients
    @report_klass = report_klass
  end

  def report
    recipients.active.find_each do |recipient|
      ReportMailer.send_report(report_for(recipient)).deliver_now
    end
  end

  def reports
    recipients.active.map do |recipient|
      ReportMailer.send_report(report_for(recipient))
    end
  end

  private

  def report_for(recipient)
    report_klass.new(recipient)
  end

  attr_reader :recipients, :report_klass
end
