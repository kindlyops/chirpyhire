class Campaign < ApplicationRecord
  belongs_to :organization
  has_one :bot_campaign
  has_one :bot, through: :bot_campaign

  has_many :campaign_contacts
  has_many :contact, through: :campaign_contacts

  has_many :messages

  def self.recent
    order(created_at: :desc)
  end
end
