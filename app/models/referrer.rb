class Referrer < ApplicationRecord
  belongs_to :user
  has_many :referrals
  has_many :candidates, through: :referrals

  delegate :phone_number, :organization, to: :user

  def refer(candidate)
    referrals.create(candidate: candidate)
  end
end
