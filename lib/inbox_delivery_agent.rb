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
    return active_bot.receive(message) if active_bot.present?
    return activated_bot.receive(message) if activated_bot.present?

    ReadReceiptsCreator.call(message, contact)
  end

  private

  def activated_bot
    @activated_bot ||= begin
      bots.find { |bot| bot.activated?(message) }
    end
  end

  def active_bot
    @active_bot ||= active_campaign_contact&.campaign&.bot
  end

  def active_campaign_contact
    @active_campaign_contact ||= begin
      active_campaign_contacts.find_by(phone_number: organization_phone_number)
    end
  end

  delegate :conversation, :contact, :organization_phone_number, to: :message
  delegate :active_campaign_contacts, to: :contact
  delegate :bots, to: :inbox
end
