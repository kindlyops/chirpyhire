class Organization < ActiveRecord::Base
  has_many :accounts
  has_many :leads
  has_many :referrers
  has_one :phone

  delegate :number, to: :phone, prefix: true
end
