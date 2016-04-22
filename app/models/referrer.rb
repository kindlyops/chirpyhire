class Referrer < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :referrals
  has_many :leads, through: :referrals

  delegate :name, :phone_number, to: :user
end
