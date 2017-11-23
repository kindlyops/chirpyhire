class BotFactory::Question::Experience < BotFactory::Question
  def body
    <<~QUESTION.strip
      How many years of professional experience do you have?
    QUESTION
  end

  def responses_and_tags
    [
      ['0 - 1', '0 - 1 years', 'Very cool! Just getting started!'],
      ['1 - 5', '1 - 5 years', 'Very cool! Just hitting your stride!'],
      ['6 or more', '6+ years', 'Very cool! We love experienced candidates!'],
      ["I'm new! So excited!", no_tag, no_follow_up_body]
    ]
  end

  def no_tag
    'No Experience'
  end

  def no_follow_up_body
    "Very cool! I'm excited too!"
  end
end
