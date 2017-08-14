class CampaignContact < ApplicationRecord
  belongs_to :campaign
  belongs_to :contact
  belongs_to :phone_number
  belongs_to :question, -> { with_deleted }, optional: true

  enum state: {
    pending: 0, active: 1, paused: 3, exited: 2
  }

  def pause
    update(state: :paused)
  end
end
