class CampaignConversation < ApplicationRecord
  belongs_to :campaign
  belongs_to :conversation

  enum state: {
    active: 0, exited: 1
  }
end
