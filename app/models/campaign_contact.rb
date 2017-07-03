class CampaignContact < ApplicationRecord
  belongs_to :campaign
  belongs_to :contact
  belongs_to :phone_number
  belongs_to :question, optional: true

  enum state: {
    pending: 0, active: 1, exited: 2
  }
end
