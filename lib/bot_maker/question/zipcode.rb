class BotMaker::Question::Zipcode < BotMaker::Question
  def body
    <<~BODY
      What is your five-digit zipcode?

      This helps us find the best cases for you!
    BODY
  end
end
