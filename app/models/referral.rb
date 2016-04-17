class Referral < ActiveRecord::Base
  belongs_to :lead
  belongs_to :team_member
end
