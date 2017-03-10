class Question::Certification < Question::MultipleChoice
  def question
    'Are you certified?'
  end

  def choices
    {
      a: 'Yes, PCA',
      b: 'Yes, CNA',
      c: 'Yes, Other (MA, LPN, RN, etc.)',
      d: 'Not Yet, but I want to be!'
    }
  end

  def inquiry
    :certification
  end

  def answer
    Answer::Certification.new(self)
  end
end
