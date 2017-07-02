class CampaignConversation < ApplicationRecord
  belongs_to :campaign
  belongs_to :conversation
  belongs_to :question, optional: true

  enum state: {
    pending: 0, active: 1, exited: 2
  }
end
