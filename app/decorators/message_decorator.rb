class MessageDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :notification
  decorates_association :inquiry
  decorates_association :answer

  delegate :name, to: :sender, prefix: true
  delegate :name, :phone_number, to: :user, prefix: true

  def sender
    @sender ||= object.sender.decorate
  end

  def recipient
    @recipient ||= object.recipient.decorate
  end

  def color
    "primary"
  end

  def icon_class
    "fa-commenting"
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

  def messageable
    (object.inquiry || object.notification || object.answer || object).class.table_name
  end

  def time_ago
    "#{h.time_ago_in_words(created_at)} ago"
  end

  def subtitle
    "Sent to #{recipient.name}"
  end
end
