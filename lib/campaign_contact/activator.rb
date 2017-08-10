class CampaignContact::Activator
  def self.call(campaign_contact)
    new(campaign_contact).call
  end

  def initialize(campaign_contact)
    @campaign_contact = campaign_contact
  end

  def call
    DeliveryAgent.call(recent_message) if recent_part_missing_campaign?
  end

  def recent_part_missing_campaign?
    recent_part.present? && recent_part.campaign.blank?
  end

  def recent_part
    @recent_part ||= recent_message&.conversation_part
  end

  def recent_message
    @recent_message ||= begin
      messages
        .where(to: phone_number.phone_number)
        .where('created_at >= ?', campaign.last_paused_at)
        .by_recency.first
    end
  end

  delegate :contact, :phone_number, :campaign, to: :campaign_contact
  delegate :messages, to: :contact

  attr_reader :campaign_contact
end
