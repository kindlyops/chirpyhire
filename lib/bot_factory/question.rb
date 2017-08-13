class BotFactory::Question
  def self.call(bot, rank:)
    new(bot, rank: rank).call
  end

  def initialize(bot, rank:)
    @bot = bot
    @rank = rank
  end

  attr_reader :bot, :rank
  delegate :organization, :next_question_action, to: :bot

  def call
    question = bot.questions.create!(
      body: body, rank: rank, follow_ups_attributes: follow_ups_attributes
    )

    bot.actions.create(type: 'QuestionAction', question_id: question.id)
  end

  def follow_ups_attributes
    responses_and_tags.map.with_index do |(response, tag, body), rank|
      {
        body: body, response: response, rank: rank + 1, action: action,
        taggings_attributes: [
          { tag_attributes: { name: tag, organization: organization } }
        ]
      }
    end
  end

  def action
    return next_question_action unless rank == 9
    bot.ranked_goals.first.action
  end

  def responses_and_tags
    []
  end
end
