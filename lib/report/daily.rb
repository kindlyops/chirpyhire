class Report::Daily < Report::Report
  delegate :name, to: :organization, prefix: true
  delegate :first_name, to: :recipient, prefix: true

  def send?
    super &&
      (qualified_count > 0 || unread_messages_count > 0)
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
    if qualified_count > 0
      if unread_messages_count > 0
        subject_suffix("#{qualified_candidates_section} "\
        "and #{pending_messages_section}")
      else
        subject_suffix(qualified_candidates_section)
      end
    else
      subject_suffix(pending_messages_section)
    end
  end

  def qualified_count
    organization.qualified_candidate_activities.where(
      created_at: date.beginning_of_day..date.end_of_day
    ).count
  end

  def unread_messages_count
    recent_unread_messages_by_user.count
  end

  def top_recent_unread_messages_by_user
    recent_unread_messages_by_user.take(5)
  end

  def recent_unread_messages_by_user
    @recent_unread_messages_by_user ||=
      organization.recent_unread_messages_by_user(
        DateTime.current - 24.hours
      )
  end

  private

  def pending_messages_section
    @pending_messages_section ||= "#{unread_messages_count} pending "\
    "#{'message'.pluralize(unread_messages_count)}"
  end

  def qualified_candidates_section
    @qualified_candidates_section ||= "#{qualified_count} Qualified "\
    "#{'Candidate'.pluralize(qualified_count)}"
  end

  def subject_suffix(message)
    "#{message} - Chirpyhire"
  end
end
