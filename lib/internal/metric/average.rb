class Internal::Metric::Average < Internal::Metric::Base
  def call
    [average].unshift("#{stage}: Average")
  end

  def average
    weekly_growth_rates.reduce(:+).fdiv(weekly_growth_rates.count)
  end

  def weekly_growth_rates
    @weekly_growth_rates ||= begin
      Internal::Metric::WeekOverWeek.new(stage, weeks).call[1..-1]
    end
  end
end
