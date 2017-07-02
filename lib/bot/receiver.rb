class Bot::Receiver
  def self.call(bot, message)
    new(bot, message).call
  end

  def initialize(bot, message)
    @bot = bot
    @message = message
  end

  attr_reader :message, :bot

  def call
    message.update!(campaign: campaign_conversation.campaign)
    return if campaign_conversation.exited?

    Bot::Responder.call(bot, message, campaign_conversation)
  end

  def campaign_conversation
    @campaign_conversation ||= begin
      existing_campaign_conversation || pending_campaign_conversation
    end
  end

  def existing_campaign_conversation
    campaign_conversations.find_by(campaign: bot_campaign.campaign)
  end

  def pending_campaign_conversation
    campaign_conversations.create!(campaign: bot_campaign.campaign)
  end

  def bot_campaign
    @bot_campaign ||= begin
      bot_campaigns.find_by(inbox: inbox)
    end
  end

  delegate :conversation, :contact, to: :message
  delegate :bot_campaigns, to: :bot
  delegate :campaign_conversations, :inbox, to: :conversation
end
