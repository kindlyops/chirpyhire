class Bot::Response
  def initialize(bot, message, campaign_contact)
    @bot = bot
    @message = message
    @campaign_contact = campaign_contact
  end

  attr_reader :message, :bot, :campaign_contact
  delegate :conversation, to: :message
  delegate :question, :campaign, to: :campaign_contact

  def sender
    bot.person
  end

  def body
    @body ||= begin
      if question.present?
        question.follow_up(message, campaign_contact)
      else
        bot.greet(message, campaign_contact)
      end
    end
  end
end
