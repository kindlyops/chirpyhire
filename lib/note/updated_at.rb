class Note::UpdatedAt
  def initialize(note)
    @note = note
  end

  attr_reader :note

  def title
    return "Today at #{time_format}" if today?
    return "Yesterday at #{time_format}" if yesterday?
    return "#{short_format} at #{time_format}" if current_year?
    "#{long_format} at #{time_format}"
  end

  def label
    note.updated_at.strftime('%I:%M %p')
  end

  def time_format
    note.updated_at.strftime('%I:%M:%S %p')
  end

  def today?
    note.updated_at > Date.current.beginning_of_day
  end

  def yesterday?
    note.updated_at > Date.yesterday.beginning_of_day
  end

  def current_year?
    note.updated_at > Date.current.beginning_of_year
  end

  def short_format
    note.updated_at.strftime("%B #{note.updated_at.day.ordinalize}")
  end

  def long_format
    note.updated_at.strftime("%B #{note.updated_at.day.ordinalize}, %Y")
  end
end
