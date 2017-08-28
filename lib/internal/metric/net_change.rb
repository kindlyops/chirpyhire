class Internal::Metric::NetChange < Internal::Metric::Base
  def call
    weeks.map do |week|
      date = Date.commercial(Date.current.year, week, 7)
      current = scope.where('contacts.created_at <= ?', date).count
      past_date = date.advance(weeks: -1)
      past = scope.where('contacts.created_at <= ?', past_date).count
      current - past
    end.unshift("#{stage}: Net Change")
  end
end
