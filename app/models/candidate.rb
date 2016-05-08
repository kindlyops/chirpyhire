class Candidate < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :referrals
  has_many :referrers, through: :referrals

  delegate :first_name, :name, :phone_number, to: :user
  delegate :name, to: :organization, prefix: true
  delegate :owner_first_name, to: :organization

  scope :subscribed, -> { joins(user: :subscriptions) }
  scope :with_phone_number, -> { joins(:user).merge(User.with_phone_number) }

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

  def subscribe
    user.subscribe_to(organization)
  end

  def subscribed?
    user.subscribed_to?(organization)
  end

  def unsubscribe
    user.unsubscribe_from(organization)
  end

  def unsubscribed?
    user.unsubscribed_from?(organization)
  end
end
