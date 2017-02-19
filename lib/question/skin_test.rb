class Question::SkinTest < Question::MultipleChoice
  def question
    'Is your TB skin test or X-ray up to date?'
  end

  def choices
    {
      a: 'Yes',
      b: 'No'
    }
  end

  def inquiry
    :skin_test
  end
end
