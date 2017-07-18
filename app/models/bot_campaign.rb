class BotCampaign < ApplicationRecord
  belongs_to :bot
  belongs_to :campaign
  belongs_to :inbox

  validates :inbox, uniqueness: { message: 'already has an active Recruitbot.' }
end
