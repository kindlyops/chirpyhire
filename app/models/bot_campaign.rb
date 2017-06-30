class BotCampaign < ApplicationRecord
  belongs_to :bot
  belongs_to :campaign
end
