class BotFactory::Question
  def self.call(bot, rank:)
    new(bot, rank: rank).call
  end

  def initialize(bot, rank:)
    @bot = bot
    @rank = rank
  end

  attr_reader :bot, :rank
  delegate :organization, to: :bot

  def call
    question = bot.questions.create!(body: body, rank: rank)
    responses_and_tags.each_with_index do |(response, tag, body), rank|
      follow_up = create_follow_up(question, body, response, rank + 1)
      tag(follow_up, tag)
    end
  end

  def create_follow_up(question, body, response, rank)
    question.follow_ups.create!(
      body: body, response: response, rank: rank
    )
  end

  def tag(follow_up, tag)
    follow_up.tags << organization.tags.find_or_create_by(name: tag)
  end

  def responses_and_tags
    []
  end
end
