class Campaign::Activator
  def self.call(campaign)
    new(campaign).call
  end

  def initialize(campaign)
    @campaign = campaign
  end

  def call
    campaign.campaign_contacts.paused.find_each do |campaign_contact|
      CampaignContact::Activator.call(campaign_contact)
    end
  end

  attr_reader :campaign
end
