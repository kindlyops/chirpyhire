class BotFactory::Question::Zipcode < BotFactory::Question
  def body
    <<~BODY
      What is your five-digit zipcode?

      This helps us find the best cases for you!
    BODY
  end

  def call
    question = bot.questions.create!(
      body: body, type: 'ZipcodeQuestion', rank: rank,
      follow_ups_attributes: follow_ups_attributes
    )
    bot.actions.create(type: 'QuestionAction', question_id: question.id)
  end

  def follow_ups_attributes
    [{
      body: follow_up_body,
      type: 'ZipcodeFollowUp',
      rank: 1,
      action: action
    }]
  end

  def action
    next_question_action
  end

  def follow_up_body
    "Thank you. It's not always possible, "\
    'but we do our best to get you convenient cases.'
  end
end
