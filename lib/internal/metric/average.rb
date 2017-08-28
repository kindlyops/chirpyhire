class Internal::Metric::Average < Internal::Metric::Base
  def call
    ["#{average}%"].unshift("Average").unshift(stage_title)
  end

  def average
    (weekly_growth_rates
      .reduce(:+).fdiv(weekly_growth_rates.count) * 100).round(2)
  end

  def weekly_growth_rates
    @weekly_growth_rates ||= begin
      Internal::Metric::WeekOverWeek.new(stage, weeks).call[2..-1]
    end
  end
end
