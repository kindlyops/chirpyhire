class Bot::Response
  def initialize(bot, message, campaign_contact)
    @bot = bot
    @message = message
    @campaign_contact = campaign_contact
  end

  attr_reader :message, :bot, :campaign_contact
end
