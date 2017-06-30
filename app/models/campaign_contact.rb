class CampaignContact < ApplicationRecord
  belongs_to :campaign
  belongs_to :contact
end
