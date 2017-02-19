class Question::Experience < Question::MultipleChoice
  def question
    <<~QUESTION
      #{welcome}

      How many years of private duty or home-care experience do you have?
    QUESTION
  end

  def choices
    {
      a: '0 - 1',
      b: '1 - 5',
      c: '6 or more',
      d: "I'm new to caregiving"
    }
  end

  def inquiry
    :experience
  end

  def welcome
    Notification::Welcome.new(subscriber).body
  end

  def answer
    Answer::Experience.new(self)
  end
end
