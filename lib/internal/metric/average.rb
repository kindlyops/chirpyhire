class Internal::Metric::Average < Internal::Metric::Base
  def call(scope)
    weekly_growth_rates = Internal::Metric::WeekOverWeek.new(weeks).call(scope)

    [weekly_growth_rates.reduce(:+).fdiv(weekly_growth_rates.count)]
  end
end
