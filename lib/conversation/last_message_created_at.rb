class Conversation::LastMessageCreatedAt
  include ActionView::Helpers::DateHelper

  def initialize(conversation)
    @conversation = conversation
  end

  def to_s
    label
  end

  attr_reader :conversation

  def label
    return time_ago_format if past_hour?
    return short_format if today?
    return 'Yesterday' if yesterday?
    return medium_format if current_year?

    long_format
  end

  def past_hour?
    time > 1.hour.ago
  end

  def today?
    time > Date.current.beginning_of_day
  end

  def yesterday?
    time > Date.yesterday.beginning_of_day
  end

  def current_year?
    time > Date.current.beginning_of_year
  end

  def time_ago_format
    time_ago_in_words(time, include_seconds: true) << " ago"
  end

  def short_format
    time.strftime('%l:%M%P')
  end

  def medium_format
    time.strftime("%B #{time.day.ordinalize}")
  end

  def long_format
    time.strftime("%B #{time.day.ordinalize}, %Y")
  end

  def time
    last_message_created_at
  end

  delegate :last_message_created_at, to: :conversation
end
