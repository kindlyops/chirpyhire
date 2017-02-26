class Question::Availability < Question::MultipleChoice
  def question
    'What is your availability?'
  end

  def choices
    {
      a: 'Live-In',
      b: 'Hourly',
      c: 'Both',
      d: 'None'
    }
  end

  def inquiry
    :availability
  end

  def answer
    Answer::Availability.new(self)
  end
end
