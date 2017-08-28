class Internal::Report::Health

  def self.call
    new.call
  end

  def call
    generate_report
    InternalMailer.health(tempfile).deliver_later
  end

  def generate_report
    CSV.open(tempfile, 'wb') do |csv|
      csv << headers
      scopes.each do |scope|
        metrics.each do |metric|
          klass = "Internal::Metric::#{metric}".constantize.new(weeks)
          csv << klass.call(scope)
        end
      end
    end
  end

  def metrics
    %w[Absolute WeekOverWeek NetChange CompoundedWeekly Average]
  end

  def headers
    weeks.each_with_object(['Growth']) do |week, acc|
      acc << "Week: #{week}"
    end
  end

  def scopes
    %i[potential screened scheduled not_now hired].map do |scope| 
      Contact.send(scope)
    end
  end

  def tempfile
    Tempfile.new('health.csv', Rails.root.join('tmp')).path
  end

  def weeks
    @weeks ||= (1..Date.current.cweek).to_a.reverse
  end

end
