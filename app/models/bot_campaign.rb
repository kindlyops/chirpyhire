class BotCampaign < ApplicationRecord
  belongs_to :bot
  belongs_to :campaign
  belongs_to :inbox
end
