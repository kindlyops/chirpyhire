class Referral < ApplicationRecord
  belongs_to :candidate
  belongs_to :referrer
end
