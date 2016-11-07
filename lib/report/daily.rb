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

  def qualified_count
    organization.qualified_candidate_activities.where(
      created_at: (DateTime.current - 24.hours)..DateTime.current
    ).count
  end

  def recipient_email
    "#{recipient.name} <#{recipient.email}>"
  end

  def subject
    "#{qualified_count} Qualified "\
    "#{'Candidate'.pluralize(qualified_count)} - Chirpyhire"
  end

  def organization
    @organization ||= recipient.organization
  end

  private

  attr_reader :recipient, :date
end
