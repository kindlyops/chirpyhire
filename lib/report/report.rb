class Report::Report
  def initialize(recipient, date: Date.current)
    @recipient = recipient
    @date = date
  end

  def organization
    @organization ||= recipient.organization
  end

  def send?
    organization.active?
  end

  protected

  attr_reader :recipient, :date
end
