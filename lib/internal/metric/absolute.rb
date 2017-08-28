class Internal::Metric::Absolute < Internal::Metric::Base
  def call
    weeks.map do |week|
      date = Date.commercial(Date.current.year, week, 7)
      scope.where('contacts.created_at <= ?', date).count
    end.unshift("Absolute").unshift(stage_title)
  end
end
