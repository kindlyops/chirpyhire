class Question::Transportation < Question::MultipleChoice
  def question
    'Do you have reliable transportation?'
  end

  def choices
    {
      a: 'I have personal transportation.',
      b: 'I use public transportation.',
      c: 'I do not have reliable transportation.'
    }
  end

  def inquiry
    :transportation
  end
end
