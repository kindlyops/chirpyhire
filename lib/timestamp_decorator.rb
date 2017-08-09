class TimestampDecorator
  include ActionView::Helpers::DateHelper

  def initialize(object, timestamp)
    @object = object
    @timestamp = object.public_send(timestamp)
  end

  attr_reader :object, :timestamp

  def label
    return '' if timestamp.blank?

    return time_ago_format if past_hour?
    return short_format if today?
    return 'Yesterday' if yesterday?
    return medium_format if current_year?

    long_format
  end

  def past_hour?
    timestamp > 1.hour.ago
  end

  def today?
    timestamp > Date.current.beginning_of_day
  end

  def yesterday?
    timestamp > Date.yesterday.beginning_of_day
  end

  def current_year?
    timestamp > Date.current.beginning_of_year
  end

  def time_ago_format
    time_ago_in_words(timestamp, include_seconds: true) << ' ago'
  end

  def short_format
    timestamp.strftime('%l:%M%P')
  end

  def medium_format
    timestamp.strftime("%B #{timestamp.day.ordinalize}")
  end

  def long_format
    timestamp.strftime("%B #{timestamp.day.ordinalize}, %Y")
  end
end
