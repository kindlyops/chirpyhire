class BotFactory::Goal
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
    goal.tap do |g|
      bot.actions.create(type: 'GoalAction', goal_id: g.id)
    end
  end

  def goal
    @goal ||= begin
      bot.goals.create!(
        body: body,
        rank: rank,
        contact_stage: stage
      )
    end
  end
end

