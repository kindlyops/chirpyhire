class BotMaker::Question::Transportation < BotMaker::Question
  def body
    <<~QUESTION.strip
      How do you plan to get to work?
    QUESTION
  end

  def responses_and_tags
    [
     ['I have personal transportation', 'Personal Transportation'], 
     ['I use public transportation', 'Public Transportation'], 
     ["I don't have a great way to get to work", 'No Transportation']
    ]
  end
end
