class Conversation::NoteDay
  def initialize(day)
    @date, @notes = day
  end

  attr_reader :date, :notes
  private
end
