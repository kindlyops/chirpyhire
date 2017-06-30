class BotMaker::Question::LiveIn < BotMaker::Question
  def body
    <<~QUESTION.strip
      Are you interested in Live-In work?
    QUESTION
  end

  def responses_and_tags
    [
     ["Yes, I'd love to!", 'Live-In', "Excellent! I've made a note of this."], 
     ['No, not for now!', 'No Live-In', "Excellent! I've made a note of this."]
    ]
  end
end
