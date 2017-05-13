class Question::Brokers::Certification < Question::MultipleChoice
  def question
    <<~QUESTION.strip
      #{welcome}

      Are you certified?
    QUESTION
  end

  def choices
    {
      a: 'Yes, CNA',
      b: 'Yes, HHA',
      c: 'Yes, Other (MA, LPN, RN, etc.)',
      d: 'Yes, PCA',
      e: 'Not yet, but I want to be!'
    }
  end

  def inquiry
    :certification
  end

  def answer
    Answer::Certification.new(self)
  end

  def welcome
    Notification::Brokers::Welcome.new(contact).body
  end
end
