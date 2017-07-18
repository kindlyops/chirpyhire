class BotFactory::Cloner
  def self.call(bot)
    new(bot).call
  end

  def initialize(bot)
    @bot = bot
  end

  attr_reader :bot

  def call; end
end
