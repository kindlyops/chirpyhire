class Lead < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :referrals
  has_many :subscriptions

  delegate :first_name, to: :user
end
