class Question::Availability < Question::MultipleChoice
  def question
    'What shifts are you interested in?'
  end

  def choices
    {
      a: 'Morning (AM) shifts are great!',
      b: 'Evening (PM) shifts are great!',
      c: "I'm wide open for AM or PM shifts!"
    }
  end

  def inquiry
    :availability
  end

  def answer
    Answer::Availability.new(self)
  end
end
