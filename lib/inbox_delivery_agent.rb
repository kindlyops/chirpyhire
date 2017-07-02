class InboxDeliveryAgent
  def self.call(inbox, message)
    new(inbox, message).call
  end

  def initialize(inbox, message)
    @inbox = inbox
    @message = message
  end

  attr_reader :message, :inbox

  def call
    return existing_bot.receive(message) if existing_bot.present?
    return activated_bot.receive(message) if activated_bot.present?

    ReadReceiptsCreator.call(message, contact)
  end

  private

  def activated_bot
    @activated_bot ||= begin
      bots.find { |bot| bot.activated?(message) }
    end
  end

  def existing_bot
    @existing_bot ||= begin
      return if bot_campaign.blank?
      bot_campaign.bot
    end
  end

  def bot_campaign
    @bot_campaign ||= begin
      conversation
        .active_bot_campaigns
        .merge(inbox.bot_campaigns).first
    end
  end

  delegate :conversation, :contact, to: :message
  delegate :bots, to: :inbox
end
