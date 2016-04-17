class Referral < ActiveRecord::Base
  belongs_to :lead
  belongs_to :team_member
  belongs_to :message
end
