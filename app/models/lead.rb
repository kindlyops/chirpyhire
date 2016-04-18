class Lead < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :referrals

  delegate :first_name, to: :user
end
