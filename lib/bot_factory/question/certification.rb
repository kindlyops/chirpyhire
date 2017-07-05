class BotFactory::Question::Certification < BotFactory::Question
  def body
    <<~QUESTION.strip
      Are you certified?
    QUESTION
  end

  def responses_and_tags
    [
      ['Yes, CNA', 'CNA', 'Fantastic, CNAs are awesome!'],
      ['Yes, HHA', 'HHA', 'Fantastic, HHAs are awesome!'],
      ['Yes, PCA', 'PCA', 'Fantastic, PCAs are awesome!'],
      ['Yes, Other (MA, LPN, RN, etc.)', 'RN, LPN, Other', 'Ok fantastic!'],
      ['Not yet, but I want to be!', 'No Certification', 'Ok fantastic!']
    ]
  end
end
