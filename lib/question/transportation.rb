class Question::Transportation < Question::MultipleChoice
  def question
    'How do you plan to get to work?'
  end

  def choices
    {
      a: 'I have personal transportation',
      b: 'I use public transportation',
      c: 'I do not have reliable transportation'
    }
  end

  def inquiry
    :transportation
  end

  def answer
    Answer::Transportation.new(self)
  end
end
