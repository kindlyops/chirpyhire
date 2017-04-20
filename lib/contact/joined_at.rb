class Contact::JoinedAt < Contact::Attribute
  def label
    return 'Today' if today?
    return 'Yesterday' if yesterday?
    return short_format if current_year?
    long_format
  end

  def today?
    contact.created_at > Date.current.beginning_of_day
  end

  def yesterday?
    contact.created_at > Date.yesterday.beginning_of_day
  end

  def current_year?
    contact.created_at > Date.current.beginning_of_year
  end

  def short_format
    contact.created_at.strftime("%B #{contact.created_at.day.ordinalize}")
  end

  def long_format
    contact.created_at.strftime("%B #{contact.created_at.day.ordinalize}, %Y")
  end
end
