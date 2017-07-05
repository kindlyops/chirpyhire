class BotFactory::Question::DriversLicense < BotFactory::Question
  def body
    <<~QUESTION.strip
      Do you have a current Driver's License?
    QUESTION
  end

  def responses_and_tags
    [
      ['Yes, of course!', "Driver's License", yes_follow_up_body],
      ['No, but I want to get one!', "No Driver's License", 'Ok great']
    ]
  end

  def yes_follow_up_body
    "Super! I'm glad you've got your license!"
  end
end
