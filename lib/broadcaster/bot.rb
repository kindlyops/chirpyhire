class Broadcaster::Bot
  def self.broadcast(bot)
    new(bot).broadcast
  end

  def initialize(bot)
    @bot = bot
  end

  def broadcast
    BotsChannel.broadcast_to(bot, bot_hash)
  end

  private

  attr_reader :bot

  def bot_hash
    JSON.parse(bot_string)
  end

  def bot_string
    BotsController.render partial: 'bots/bot', locals: { bot: bot }
  end
end
