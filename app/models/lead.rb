class Lead < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :referrals
  has_many :inquiries
  has_many :answers

  delegate :first_name, to: :user
end
