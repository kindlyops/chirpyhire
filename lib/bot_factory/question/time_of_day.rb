class BotFactory::Question::TimeOfDay < BotFactory::Question
  def body
    <<~QUESTION.strip
      What time would you like to come in? We have interviews between 9am and 3pm.
    QUESTION
  end

  def responses_and_tags
    [
      ['Morning (9am - 12pm)', 'Interview: Morning', morning_follow_up],
      ['Afternoon (12pm - 3pm)', 'Interview: Afternoon', afternoon_follow_up]
    ]
  end

  def morning_follow_up
    "Cool, I'll make a note that you'll be coming in the morning."
  end

  def afternoon_follow_up
    "Cool, I'll make a note that you'll be coming in the afternoon."
  end
end
