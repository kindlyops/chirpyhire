class Question::Certification < Question::MultipleChoice
  def question
    <<~QUESTION.strip
      Are you certified?
    QUESTION
  end

  def choices
    {
      a: 'Yes, CNA',
      b: 'Yes, HHA',
      c: 'Yes, PCA',
      d: 'Yes, Other (MA, LPN, RN, etc.)',
      e: 'Not yet, but I want to be!'
    }
  end

  def inquiry
    :certification
  end

  def answer
    Answer::Certification.new(self)
  end
end
