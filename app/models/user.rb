class User < ActiveRecord::Base
  phony_normalize :phone_number, default_country_code: 'US'
  has_many :leads
  has_many :referrers
  has_many :subscriptions

  def subscribed_to?(organization)
    subscriptions.where(organization: organization).exists?
  end

  def subscription_to(organization)
    subscriptions.find_by(organization: organization)
  end

  def subscribe_to(organization)
    subscriptions.create(organization: organization)
  end

  def unsubscribed_from?(organization)
    !subscribed_to?(organization)
  end

  def unsubscribe_from(organization)
    subscriptions.find_by(organization: organization).destroy
  end
end
