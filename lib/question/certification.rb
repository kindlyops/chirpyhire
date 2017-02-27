class Question::Certification < Question::MultipleChoice
  def question
    'Are you currently licensed or certified?'
  end

  def choices
    {
      a: 'Yes, PCA',
      b: 'Yes, CNA',
      c: 'Yes, Other (MA, LPN, RN, etc.)',
      d: 'No Certification'
    }
  end

  def inquiry
    :certification
  end

  def answer
    Answer::Certification.new(self)
  end
end
