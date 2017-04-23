class Note::Day
  def initialize(day)
    @date, @notes = day
  end

  attr_reader :date, :notes
end
