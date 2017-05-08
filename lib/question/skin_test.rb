class Question::SkinTest < Question::MultipleChoice
  def question
    'Is your TB skin test or X-ray up to date?'
  end

  def choices
    {
      a: 'Yes, of course!',
      b: 'No, but I want it to be!'
    }
  end

  def inquiry
    :skin_test
  end

  def answer
    Answer::SkinTest.new(self)
  end
end
