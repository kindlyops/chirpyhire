class Report::Daily < Report::Report
  delegate :name, to: :organization, prefix: true
  delegate :first_name, to: :recipient, prefix: true

  def send?
    super && (qualified_count > 0 || unanswered_inquiry_responses.count > 0)
  end

  def template_name
    'daily'
  end

  def humanized_date
    date.strftime("%B #{date.day.ordinalize}")
  end

  def recipient_email
    "#{recipient.name} <#{recipient.email}>"
  end

  def subject
    "#{qualified_count} Qualified "\
    "#{'Candidate'.pluralize(qualified_count)} - Chirpyhire"
  end

  def qualified_count
    organization.qualified_candidate_activities.where(
      created_at: date.beginning_of_day..date.end_of_day
    ).count
  end

  def unanswered_inquiry_responses
    @unanswered_inquiry_responses ||= organization.inquiry_activities(1.day.ago)
  end
end
