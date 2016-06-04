class ActivityDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  delegate :color, :icon_class, :body, to: :trackable
  delegate :organization, :from, :from_short, to: :user

  def day
    "#{friendly_day} #{created_at.strftime('%B %d')}".squish
  end

  def trackable
    @trackable ||= "#{object.trackable.class}Decorator".constantize.new(object.trackable)
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
end
