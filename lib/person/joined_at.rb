class Person::JoinedAt < Person::Attribute
  def label
    return 'Today' if today?
    return 'Yesterday' if yesterday?
    return short_format if current_year?
    long_format
  end

  def today?
    person.created_at > Date.current.beginning_of_day
  end

  def yesterday?
    person.created_at > Date.yesterday.beginning_of_day
  end

  def current_year?
    person.created_at > Date.current.beginning_of_year
  end

  def short_format
    person.created_at.strftime("%B #{person.created_at.day.ordinalize}")
  end

  def long_format
    person.created_at.strftime("%B #{person.created_at.day.ordinalize}, %Y")
  end
end
