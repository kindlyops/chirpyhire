class Candidate < ActiveRecord::Base
  belongs_to :user
  has_many :referrals
  has_many :referrers, through: :referrals

  enum status: [:potential, :qualified, :bad_fit]

  delegate :first_name, :name, :phone_number, :organization_name,
           :owner_first_name, :organization, to: :user

  scope :subscribed, -> { where(subscribed: true) }

  def last_referrer
    @last_referrer ||= begin
      return NullReferrer.new unless referrers.present?
      last_referral.referrer
    end
  end

  def last_referral
    @last_referral ||= begin
      return NullReferral.new unless referrals.present?
      referrals.order(:created_at).last
    end
  end

  def last_referred_at
    last_referral.created_at
  end

  def last_referrer_name
    last_referrer.name
  end

  def last_referrer_phone_number
    last_referrer.phone_number
  end

  def unsubscribed?
    !subscribed?
  end
end
