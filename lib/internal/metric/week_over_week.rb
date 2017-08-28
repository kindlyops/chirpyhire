class Internal::Metric::WeekOverWeek < Internal::Metric::Base
  def call
    weeks.map do |week|
      date = Date.commercial(Date.current.year, week, 7)
      past_date = date.advance(weeks: -1)
      past = scope.where('contacts.created_at <= ?', past_date).count

      if past.zero?
        0
      else
        current = scope.where('contacts.created_at <= ?', date).count
        (current - past).fdiv(past)
      end
    end.unshift("#{stage}: W-o-W")
  end
end
