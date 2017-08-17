class BotFactory::Question::WeekDay < BotFactory::Question
  def body
    <<~QUESTION.strip
      I'd love to invite you to interview! What day would you like to come in?
    QUESTION
  end

  def responses_and_tags
    [
      ['Monday', 'Interview: Monday', day_follow_up('Monday')],
      ['Tuesday', 'Interview: Tuesday', day_follow_up('Tuesday')],
      ['Wednesday', 'Interview: Wednesday', day_follow_up('Wednesday')],
      ['Thursday', 'Interview: Thursday', day_follow_up('Thursday')],
      ['Friday', 'Interview: Friday', day_follow_up('Friday')]
    ]
  end

  def day_follow_up(day)
    "Great, we'll see you #{day}!"
  end
end
