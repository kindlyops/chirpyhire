class Internal::Metric::CompoundedWeekly < Internal::Metric::Base
  def call
    ["#{compounded_weekly}%"].unshift("CWGR").unshift(stage_title)
  end

  def compounded_weekly
    return 0 if beginning.zero? || weeks.zero?

    ((((ending.fdiv(beginning))**(1.fdiv(weeks.count))) - 1) * 100).round(2)
  end

  def ending
    last_week = weeks.first

    last_date = Date.commercial(Date.current.year, last_week, 7)
    scope.where('contacts.created_at <= ?', last_date).count
  end

  def beginning
    first_week = weeks.last
    first_date = Date.commercial(Date.current.year, first_week, 7)
    scope.where('contacts.created_at <= ?', first_date).count
  end
end
