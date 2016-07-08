class Referrer < ApplicationRecord
  belongs_to :user
  has_many :referrals
  has_many :candidates, through: :referrals

  delegate :phone_number, :organization, to: :user

  def refer(candidate)
    referrals.create(candidate: candidate)
  end

  def last_referral
    @last_referral ||= begin
      return NullReferral.new unless referrals.present?
      referrals.order(:created_at).last
    end
  end

  def last_referred
    @last_referred ||= begin
      return NullCandidate.new unless candidates.present?
      last_referral.candidate
    end
  end
end
