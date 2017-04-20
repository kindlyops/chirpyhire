class Contact::LastActiveAt < Contact::Attribute
  include ActionView::Helpers::DateHelper

  def label
    return time_ago_format if past_hour?
    return short_format if today?
    return 'Yesterday' if yesterday?
    return medium_format if current_year?

    long_format
  end

  def past_hour?
    last_reply_at > 1.hour.ago
  end

  def today?
    last_reply_at > Date.current.beginning_of_day
  end

  def yesterday?
    last_reply_at > Date.yesterday.beginning_of_day
  end

  def current_year?
    last_reply_at > Date.current.beginning_of_year
  end

  def time_ago_format
    time_ago_in_words(last_reply_at, include_seconds: true)
  end

  def short_format
    last_reply_at.strftime('%l:%M%P')
  end

  def medium_format
    last_reply_at.strftime("%B #{last_reply_at.day.ordinalize}")
  end

  def long_format
    last_reply_at.strftime("%B #{last_reply_at.day.ordinalize}, %Y")
  end

  delegate :last_reply_at, to: :contact
end
