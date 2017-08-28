class Internal::Metric::Absolute < Internal::Metric::Base
  def call(scope)
    weeks.map do |week|
      date = Date.commercial(Date.current.year, week, 7)
      scope.where('contacts.created_at <= ?', date).count
    end
  end
end
