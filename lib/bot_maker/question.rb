class BotMaker::Question
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
    question = bot.questions.create(body: body, rank: rank)
    responses_and_tags.each do |response, tag, body|
      follow_up = question.follow_ups.create(body: body, response: response)
      follow_up.tags << organization.tags.find_or_create_by(name: tag)
    end
  end

  def responses_and_tags
    []
  end
end
