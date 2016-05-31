class TaskDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  delegate :color, :icon_class, :body, to: :taskable
  delegate :organization, :from, :from_short, to: :user

  def day
    "#{friendly_day} #{created_at.strftime('%B %d')}".squish
  end

  def taskable
    @taskable ||= "#{object.taskable.class}Decorator".constantize.new(object.taskable)
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
      "#{friendly_day} at#{created_at.strftime('%l:%M%P')}"
    else
      "#{created_at.strftime('%B %d')} at#{created_at.strftime('%l:%M%P')}"
    end
  end
end
