class BotFactory::Question::Zipcode < BotFactory::Question
  def body
    <<~BODY
      What is your five-digit zipcode?

      This helps us find the best cases for you!
    BODY
  end

  def call
    question = bot.questions.create(
      body: body, type: 'ZipcodeQuestion', rank: rank
    )
    bot.actions.create(type: 'QuestionAction', question_id: question.id)
    question.follow_ups.create(
      body: follow_up_body, type: question.follow_up_type, rank: 1
    )
  end

  def follow_up_body
    "Thank you. It's not always possible, "\
    'but we do our best to get you convenient cases.'
  end
end
