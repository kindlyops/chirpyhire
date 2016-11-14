class Report::Report
  def initialize(recipient, date: Date.current)
    @recipient = recipient
    @date = date
    @now = DateTime.current
  end

  def organization
    @organization ||= recipient.organization
  end

  def send?
    organization.good_standing?
  end

  protected

  attr_reader :recipient, :date, :now
end
