class Referral < ActiveRecord::Base
  belongs_to :lead
  belongs_to :referrer
  belongs_to :message
end
