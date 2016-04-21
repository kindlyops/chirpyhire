class Referrer < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :referrals

  delegate :name, :phone_number, to: :user
end
