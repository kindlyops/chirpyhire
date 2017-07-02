class Campaign < ApplicationRecord
  has_one :bot_campaign
  has_one :bot, through: :bot_campaign

  has_many :campaign_conversations
  has_many :conversations, through: :campaign_conversations

  has_many :messages
end
