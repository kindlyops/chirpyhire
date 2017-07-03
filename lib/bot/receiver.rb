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
    message.update!(campaign: campaign_contact.campaign)
    return if campaign_contact.exited?

    reply(Bot::Response.new(bot, message, campaign_contact))
  end

  def campaign_contact
    @campaign_contact ||= begin
      existing_campaign_contact || pending_campaign_contact
    end
  end

  def existing_campaign_contact
    campaign_contacts.find_by(campaign: bot_campaign.campaign)
  end

  def pending_campaign_contact
    campaign_contacts.create!(
      campaign: bot_campaign.campaign,
      phone_number: organization_phone_number
    )
  end

  def bot_campaign
    @bot_campaign ||= begin
      bot_campaigns.find_by(inbox: inbox)
    end
  end

  def reply(response)
    return if response.body.blank?

    organization.message(
      sender: response.sender,
      conversation: response.conversation,
      body: response.body
    )
  end

  delegate :contact, :organization_phone_number, :conversation, to: :message
  delegate :bot_campaigns, to: :bot
  delegate :inbox, :organization, to: :conversation
  delegate :campaign_contacts, to: :contact
end
