class Question::Brokers::Certification < Question::MultipleChoice
  def question
    <<~QUESTION.strip
      #{welcome}

      Are you certified?
    QUESTION
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

  def welcome
    Notification::Brokers::Welcome.new(contact).body
  end
end
