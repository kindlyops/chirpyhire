class Reminder::Base
  def self.call(reminder)
    new(reminder).call
  end

  def initialize(reminder)
    @reminder = reminder
  end

  attr_reader :reminder
  delegate :to_datetime, to: :reminder

  def more_than_one_day_out?
    to_datetime >= 1.day.from_now
  end

  def less_than_day_but_more_than_one_hour_out?
    to_datetime >= 1.hour.from_now && !more_than_one_day_out?
  end

  def less_than_one_hour_out?
    to_datetime < 1.hour.from_now
  end
end
