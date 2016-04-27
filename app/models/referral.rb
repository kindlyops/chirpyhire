class Referral < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :referrer
  belongs_to :message
end
