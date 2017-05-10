class Question::LiveIn < Question::MultipleChoice
  def question
    'Are you interested in Live-In work?'
  end

  def choices
    {
      a: "Yes, I'd love to!",
      b: 'No, not for now!'
    }
  end

  def inquiry
    :live_in
  end

  def answer
    Answer::LiveIn.new(self)
  end
end
