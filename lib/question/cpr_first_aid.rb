class Question::CprFirstAid < Question::MultipleChoice
  def question
    'Is your CPR / First Aid certification up to date?'
  end

  def choices
    {
      a: 'Yes',
      b: 'No'
    }
  end

  def inquiry
    :cpr_first_aid
  end

  def answer
    Answer::CprFirstAid.new(self)
  end
end
