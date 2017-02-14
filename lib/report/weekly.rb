class Report::Weekly < Report::Report
  delegate :name, to: :organization, prefix: true
  delegate :first_name, to: :recipient, prefix: true

  def humanized_week
    start_of_week << ' - ' << end_of_week
  end

  def template_name
    'weekly'
  end

  def start_of_week
    (date - 7).strftime("%B #{(date - 7).day.ordinalize}")
  end

  def end_of_week
    (date - 1).strftime("%B #{(date - 1).day.ordinalize}")
  end

  def hired_count
    organization
      .hired_candidate_activities
      .where('candidates.created_at BETWEEN ? AND ?',
             now - 7.days,
             now).count
  end

  def qualified_count
    organization
      .qualified_candidate_activities
      .where('candidates.created_at BETWEEN ? AND ?',
             now - 7.days,
             now).count
  end

  def potential_count
    organization
      .potential_candidate_activities
      .where('candidates.created_at BETWEEN ? AND ?',
             now - 7.days,
             now).count
  end

  def bad_fit_count
    organization
      .bad_fit_candidate_activities
      .where('candidates.created_at BETWEEN ? AND ?',
             now - 7.days,
             now).count
  end

  def recipient_email
    "#{recipient.name} <#{recipient.email}>"
  end

  def subject
    'Weekly Activity Report - ChirpyHire'
  end
end
