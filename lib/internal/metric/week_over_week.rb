class Internal::Metric::WeekOverWeek < Internal::Metric::Base
  def values
    weeks.map(&method(:to_value))
  end

  def call
    values.map do |value|
      "#{(value * 100).round(2)}%"
    end.unshift('W-o-W').unshift(stage_title)
  end

  def to_value(week)
    date = Date.commercial(Date.current.year, week, 7)
    past_date = date.advance(weeks: -1)
    past = scope.where('contacts.created_at <= ?', past_date).count

    if past.zero?
      0
    else
      current = scope.where('contacts.created_at <= ?', date).count
      (current - past).fdiv(past)
    end
  end
end
