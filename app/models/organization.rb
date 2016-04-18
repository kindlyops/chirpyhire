class Organization < ActiveRecord::Base
  has_many :accounts
  has_many :leads
  has_many :referrals, through: :leads
  has_many :referrers
  has_many :messages
  has_one :phone

  delegate :number, to: :phone, prefix: true

  def sms_client
    @sms_client ||= Sms::Client.new(self)
  end

  def owner
    accounts.find_by(role: Account.roles[:owner])
  end

  def owner_first_name
    owner.first_name
  end
end
