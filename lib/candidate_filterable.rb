class CandidateFilterable
  CREATED_IN_OPTIONS = {
    PAST_24_HOURS: 'Past 24 Hours',
    PAST_WEEK: 'Past Week',
    PAST_MONTH: 'Past Month',
    ALL_TIME: 'All Time'
  }.freeze

  def self.min_date(created_in)
    {
      CREATED_IN_OPTIONS[:PAST_24_HOURS] => 24.hours.ago,
      CREATED_IN_OPTIONS[:PAST_WEEK] => 1.week.ago,
      CREATED_IN_OPTIONS[:PAST_MONTH] => 1.month.ago,
      CREATED_IN_OPTIONS[:ALL_TIME] => Date.iso8601('2016-02-01')
    }[created_in]
  end
end
