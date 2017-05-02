class Question::Availability < Question::MultipleChoice
  def question
    'What is your availability?'
  end

  def choices
    {
      a: 'Live-In',
      b: 'Hourly - AM',
      c: 'Hourly - PM',
      d: "I'm wide open for any shifts!"
    }
  end

  def inquiry
    :availability
  end

  def answer
    Answer::Availability.new(self)
  end
end
