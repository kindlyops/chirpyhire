class BotMaker::Question::Availability < BotMaker::Question
  def body
    <<~QUESTION.strip
      What shifts are you interested in?
    QUESTION
  end

  def responses_and_tags
    [
      ['Morning (AM) shifts are great!', 'AM', am_follow_up_body],
      ['Evening (PM) shifts are great!', 'PM', pm_follow_up_body],
      ["I'm wide open for AM or PM shifts!", 'AM/PM', open_follow_up_body]
    ]
  end

  def am_follow_up_body
    "Nice! I've made a note you are interested in AM shifts"
  end

  def pm_follow_up_body
    "Nice! I've made a note you are interested in PM shifts"
  end

  def open_follow_up_body
    'Nice! I appreciate your flexibility!'
  end
end
