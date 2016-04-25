class Referrer < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :referrals
  has_many :leads, through: :referrals

  delegate :name, :phone_number, to: :user

  def last_referral
    @last_referral ||= begin
      return NullReferral.new unless referrals.present?
      referrals.order(:created_at).last
    end
  end

  def last_referred
    @last_referred ||= begin
      return NullLead.new unless leads.present?
      last_referral.lead
    end
  end

  def last_referral_at
    last_referral.created_at
  end

  def last_referral_name
    last_referred.name
  end

  def refer(lead, message)
    referrals.create(lead: lead, message: message)
  end
end
