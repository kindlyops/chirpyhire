class Lead < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :referrals
  has_one :subscription

  delegate :first_name, to: :user
end
