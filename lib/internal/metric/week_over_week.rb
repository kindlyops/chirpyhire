class Internal::Metric::WeekOverWeek < Internal::Metric::Base
  def call(scope)
    weeks.map do |week|
      date = Date.commercial(Date.current.year, week, 7)
      current = scope.where('contacts.created_at <= ?', date).count
      past_date = date.advance(weeks: -1)
      past = scope.where('contacts.created_at <= ?', past_date).count
      (current - past).fdiv(past)
    end
  end
end
