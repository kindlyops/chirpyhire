class BotMaker::Question::Transportation < BotMaker::Question
  def body
    <<~QUESTION.strip
      How do you plan to get to work?
    QUESTION
  end

  def responses_and_tags
    [
      ['I have personal transportation', personal_tag, personal_follow_up_body],
      ['I use public transportation', public_tag, public_follow_up_body],
      ["I don't have a great way to get to work", no_tag, 'Ok cool.']
    ]
  end

  def no_tag
    'No Transportation'
  end

  def personal_tag
    'Personal Transportation'
  end

  def public_tag
    'Public Transportation'
  end

  def personal_follow_up_body
    'Vroom! Vroom! Glad you have a set of wheels.'
  end

  def public_follow_up_body
    'Ok cool. Glad you have access to public transit.'
  end
end
