class BotMaker::Question::CprFirstAid < BotMaker::Question
  def body
    <<~QUESTION.strip
      Is your CPR / First Aid certification up to date?
    QUESTION
  end

  def responses_and_tags
    [
      ['Yes, of course!', 'CPR / 1st Aid', yes_follow_up_body],
      ['No, but I want it to be!', 'No CPR / 1st Aid', 'Ok thanks']
    ]
  end

  def yes_follow_up_body
    "Glad you've got your CPR / 1st Aid certification under your belt!"
  end
end
