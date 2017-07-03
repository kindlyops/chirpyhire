class Bot::Responder
  def self.call(bot, message, campaign_contact)
    new(bot, message, campaign_contact).call
  end

  def initialize(bot, message, campaign_contact)
    @bot = bot
    @message = message
    @campaign_contact = campaign_contact
  end

  attr_reader :message, :bot, :campaign_contact

  def call
    # consider_answer if campaign_contact.active?
    # start if campaign_contact.pending?
  end

  def start
    campaign.reply(response)
    campaign_contact.update(state: :active)
  end

  def consider_answer
    tagger.call
    logger.call
    notifier.call
    campaign.reply(response)
  end

  def notifier
    @notifier ||= begin
      Bot::Notifier.new(contact, response)
    end
  end

  def logger
    @logger ||= begin
      Bot::Logger.new(contact, response)
    end
  end

  def tagger
    @tagger ||= begin
      Bot::Tagger.new(contact, response)
    end
  end

  def response
    @response ||= begin
      Bot::Response.new(bot, message, campaign_contact)
    end
  end

  delegate :question, :campaign, to: :campaign_contact
  delegate :organization, to: :bot
  delegate :contact, to: :message
end
