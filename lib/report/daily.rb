class Report::Daily < Report::Report
  delegate :name, to: :organization, prefix: true
  delegate :first_name, to: :recipient, prefix: true

  def send?
    return true
    super &&
      (qualified_count > 0 || unanswered_inquiry_count > 0)
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
    qualified_candidates_section = "#{qualified_count} Qualified "\
    "#{'Candidate'.pluralize(qualified_count)}"
    pending_messages_section = "#{unanswered_inquiry_count} pending "\
    "#{'message'.pluralize(unanswered_inquiry_count)}"
    suffix = "- Chirpyhire"

    if qualified_count > 0
      if unread_message_count > 0
        "#{qualified_candidates_section} and #{pending_messages_section} #{suffix}"
      else
        "#{qualified_candidates_section} #{suffix}"
      end
    else
      "#{pending_messages_section} #{suffix}"
    end
  end

  def qualified_count
    organization.qualified_candidate_activities.where(
      created_at: date.beginning_of_day..date.end_of_day
    ).count
  end

  def unanswered_inquiry_count
    unanswered_inquiry_messages.count
  end

  def top_unanswered_inquiry_messages
    unanswered_inquiry_messages.take(5)
  end

  def unanswered_inquiry_messages
    @unanswered_inquiries_messages ||=
      organization.unanswered_inquiry_messages(
        DateTime.current - 24.hours
      )
  end
end
