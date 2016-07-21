class Report::Daily

  def initialize(recipient, date: Date.current)
    @recipient = recipient
    @date = date
  end

  delegate :name, to: :organization, prefix: true
  delegate :first_name, to: :recipient, prefix: true

  def humanized_date
    date.strftime("%B #{date.day.ordinalize}")
  end

  def screened_count
    organization.candidates.screened.where(created_at: date.beginning_of_day..date.end_of_day).count
  end

  def recipient_email
    "#{recipient.name} <#{recipient.email}>"
  end

  def subject
    "#{screened_count} Screened #{'Candidate'.pluralize(screened_count)} - Chirpyhire"
  end

  private

  def organization
    @organization ||= recipient.organization
  end

  attr_reader :recipient, :date
end
