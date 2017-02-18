class Organization < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  has_many :accounts
  has_many :leads
  has_one :subscription
  has_one :ideal_candidate

  def persisted_subscription?
    subscription.present? && subscription.persisted?
  end

  def new_subscription?
    subscription.present? && subscription.new_record?
  end
end
