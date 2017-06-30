class BotMaker::Question::SkinTest < BotMaker::Question
  def body
    <<~QUESTION.strip
      Is your TB skin test or X-ray up to date?
    QUESTION
  end

  def responses_and_tags
    [
     ['Yes, of course!', 'Skin / TB Test', yes_follow_up_body], 
     ['No, but I want it to be!', 'No Skin / TB Test', "Ok thanks"]
    ]
  end

  def yes_follow_up_body
    "Thanks for keeping your test up to date!"
  end
end
