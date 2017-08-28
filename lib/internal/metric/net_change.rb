class Internal::Metric::NetChange < Internal::Metric::Base
  def call
    weeks.map(&method(:to_value)).unshift('Net Change').unshift(stage_title)
  end

  def to_value(week)
    date = Date.commercial(Date.current.year, week, 7)
    current = scope.where('contacts.created_at <= ?', date).count
    past_date = date.advance(weeks: -1)
    past = scope.where('contacts.created_at <= ?', past_date).count
    current - past
  end
end
