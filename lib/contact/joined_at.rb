class Contact::JoinedAt < Contact::Attribute
  include ActionView::Helpers::DateHelper

  def label
    long_format
  end

  def today?
    created_at > Date.current.beginning_of_day
  end

  def yesterday?
    created_at > Date.yesterday.beginning_of_day
  end

  def current_year?
    created_at > Date.current.beginning_of_year
  end

  def short_format
    created_at.strftime("%B #{created_at.day.ordinalize}")
  end

  def long_format
    created_at.strftime("%B #{created_at.day.ordinalize}, %Y")
  end

  def time_ago_format
    time_ago_in_words(created_at, include_seconds: true) << " ago"
  end

  delegate :created_at, to: :contact
end
