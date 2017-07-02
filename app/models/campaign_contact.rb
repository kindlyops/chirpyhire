class CampaignContact < ApplicationRecord
  belongs_to :campaign
  belongs_to :contact

  enum state: {
    pending: 0, in_progress: 1, complete: 2
  }
end
