class Report::Weekly

  def initialize(recipient, date: Date.current)
    @recipient = recipient
    @date = date
  end

  delegate :name, to: :organization, prefix: true
  delegate :first_name, to: :recipient, prefix: true

  def humanized_week
    (date - 7).strftime("%B #{(date - 7).day.ordinalize}") << " - " << (date - 1).strftime("%B #{(date - 1).day.ordinalize}")
  end

  def hired_count
    organization.candidate_activities.hired.where("candidates.created_at BETWEEN ?::date - 7 AND ?::date - 1", date, date).count
  end

  def qualified_count
    organization.candidate_activities.qualified.where("candidates.created_at BETWEEN ?::date - 7 AND ?::date - 1", date, date).count
  end

  def potential_count
    organization.candidate_activities.potential.where("candidates.created_at BETWEEN ?::date - 7 AND ?::date - 1", date, date).count
  end

  def bad_fit_count
    organization.candidate_activities.bad_fit.where("candidates.created_at BETWEEN ?::date - 7 AND ?::date - 1", date, date).count
  end

  def recipient_email
    "#{recipient.name} <#{recipient.email}>"
  end

  def subject
    "Weekly Activity Report - Chirpyhire"
  end

  private

  def organization
    @organization ||= recipient.organization
  end

  attr_reader :recipient, :date
end
