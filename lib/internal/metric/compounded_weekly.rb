class Internal::Metric::CompoundedWeekly < Internal::Metric::Base
  def call(scope)
    first_week = weeks.last
    last_week = weeks.first

    last_date = Date.commercial(Date.current.year, last_week, 7)
    ending = scope.where('contacts.created_at <= ?', last_date).count

    first_date = Date.commercial(Date.current.year, first_week, 7)
    beginning = scope.where('contacts.created_at <= ?', first_date).count

    [((ending.fdiv(beginning))**(1.fdiv(weeks.count))) - 1]
  end
end
