class MessageDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :activities

  delegate :from, to: :user

  def subtitle
    ""
  end

  def to
    organization.name
  end

  def time_ago
    "#{h.time_ago_in_words(created_at)} ago"
  end

  def friendly_day
    day = created_at.strftime('%B %d')
    if day == Date.today.strftime('%B %d')
      "Today"
    elsif day == Date.yesterday.strftime('%B %d')
      "Yesterday"
    end
  end

  def time_at
    if friendly_day
      "#{friendly_day} at #{created_at.strftime('%l:%M%P')}"
    else
      "#{created_at.strftime('%B %d')} at #{created_at.strftime('%l:%M%P')}"
    end
  end

  def color
    "primary"
  end

  def icon_class
    "fa-commenting-o"
  end

  def attachments
    media_instances
  end
end
