class Referrer < ActiveRecord::Base
  belongs_to :user
  has_many :referrals
  has_many :candidates, through: :referrals
  has_one :trigger, as: :observable

  delegate :name, :phone_number, :organization, to: :user

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

  def last_referral_at
    last_referral.created_at
  end

  def last_referral_name
    last_referred.name
  end

  def refer(candidate)
    referrals.create(candidate: candidate)
  end
end
