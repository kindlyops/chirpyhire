class BotDeliveryAgent
  def self.call(bot, message)
    new(bot, message).call
  end

  def initialize(bot, message)
    @bot = bot
    @message = message
  end

  attr_reader :message, :bot

  def call; end
end
