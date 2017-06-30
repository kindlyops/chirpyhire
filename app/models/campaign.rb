class Campaign < ApplicationRecord
  has_one :bot_campaign
  has_one :bot, through: :bot_campaign

  has_many :campaign_contacts
  has_many :contacts, through: :campaign_contacts
end
