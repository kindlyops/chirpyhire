class Candidate < ActiveRecord::Base
  belongs_to :user
  has_many :referrals
  has_many :referrers, through: :referrals

  validates :status, inclusion: { in: %w(potential qualified bad_fit) }

  delegate :first_name, :phone_number, :organization_name,
           :organization, to: :user

  delegate :contact_first_name, to: :organization
  delegate :created_at, to: :last_referral, prefix: true

  scope :subscribed, -> { where(subscribed: true) }

  def last_referral
    @last_referral ||= begin
      return NullReferral.new unless referrals.present?
      referrals.order(:created_at).last
    end
  end

  def last_referrer
    @last_referrer ||= begin
      return NullReferrer.new unless referrers.present?
      last_referral.referrer
    end
  end

  def unsubscribed?
    !subscribed?
  end
end
