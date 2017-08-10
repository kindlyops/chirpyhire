class Campaign::Pauser
  def self.call(campaign)
    new(campaign).call
  end

  def initialize(campaign)
    @campaign = campaign
  end

  def call
    campaign.campaign_contacts.active.find_each(&:pause)
  end

  attr_reader :campaign
end
