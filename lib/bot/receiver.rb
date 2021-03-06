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
    return if campaign.paused?
    conversation_part.update!(campaign: campaign_contact.campaign)
    return if campaign_contact.exited?

    reply
  end

  def campaign_contact
    @campaign_contact ||= begin
      existing_campaign_contact || pending_campaign_contact
    end
  end

  def existing_campaign_contact
    campaign_contacts.where.not(state: :exited).find_by(campaign: campaign)
  end

  def pending_campaign_contact
    campaign_contacts.create!(
      campaign: campaign,
      phone_number: organization_phone_number
    )
  end

  def bot_campaign
    @bot_campaign ||= begin
      bot_campaigns.find_by(inbox: inbox)
    end
  end

  def response
    @response ||= Bot::Response.new(bot, message, campaign_contact)
  end

  def reply
    return if response_body.blank?

    organization.message(
      sender: response_sender,
      phone_number: response_conversation.phone_number,
      recipient: response_conversation.contact.person,
      body: response_body
    ).tap(&method(:create_part))
  end

  def create_part(message)
    response_conversation.parts.create(
      message: message,
      happened_at: message.external_created_at,
      campaign: response_campaign
    ).tap(&:touch_conversation)
  end

  delegate :contact, :organization_phone_number, :conversation,
           :conversation_part, to: :message
  delegate :bot_campaigns, to: :bot
  delegate :inbox, :organization, to: :conversation
  delegate :campaign_contacts, to: :contact
  delegate :campaign, to: :bot_campaign
  delegate :sender, :conversation, :body, :campaign, to: :response, prefix: true
end
