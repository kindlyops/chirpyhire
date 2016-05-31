class TaskDecorator < Draper::Decorator
  delegate_all

  delegate :color, :icon_class, :body, to: :taskable

  def day
    day = created_at.strftime('%B %d')
    if day == Date.today.strftime('%B %d')
      "Today #{day}"
    elsif day == Date.yesterday.strftime('%B %d')
      "Yesterday #{day}"
    else
      day
    end
  end

  def taskable
    @taskable ||= "#{object.taskable.class}Decorator".constantize.new(object.taskable)
  end

  def from
    taskable.user_name || taskable.user_phone_number
  end

  def time
    "#{h.time_ago_in_words(created_at)} ago"
  end
end
