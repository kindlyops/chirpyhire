class Question::Availability < Question::MultipleChoice
  def question
    'What is your availability?'
  end

  def choices
    {
      a: 'Live-In',
      b: 'Full-Time',
      c: 'Part-Time',
      d: 'All the above'
    }
  end

  def inquiry
    :availability
  end
end
