class BotMaker::Question::Zipcode < BotMaker::Question
  def body
    <<~BODY
      What is your five-digit zipcode?

      This helps us find the best cases for you!
    BODY
  end

  def call
    question = bot.questions.create(
      body: body, type: 'ZipcodeQuestion'
    )
    question.follow_ups.create(
      body: follow_up_body, type: question.follow_up_type
    )
  end

  def follow_up_body
    "Thank you. It's not always possible, "\
    'but we do our best to get you convenient cases.'
  end
end
