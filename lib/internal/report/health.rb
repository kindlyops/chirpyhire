class Internal::Report::Health
  def self.call
    new.call
  end

  def call
    CSV.generate do |csv|
      csv << headers
      stages.each do |stage|
        metrics.each do |metric|
          klass = "Internal::Metric::#{metric}".constantize
          csv << klass.new(stage, weeks).call
        end
      end
    end
  end

  def metrics
    %w[Absolute WeekOverWeek NetChange CompoundedWeekly Average]
  end

  def headers
    weeks.each_with_object(%w[Stage Metric]) do |week, acc|
      acc << "Week: #{week}"
    end
  end

  def stages
    %i[potential screened scheduled not_now hired]
  end

  def tempfile
    Tempfile.new('health.csv', Rails.root.join('tmp')).path
  end

  def weeks
    @weeks ||= (1..Date.current.cweek).to_a.reverse
  end
end
