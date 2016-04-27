class User < ActiveRecord::Base
  phony_normalize :phone_number, default_country_code: 'US'
  has_many :candidates
  has_many :referrers
  has_many :subscriptions

  scope :with_phone_number, -> { where.not(phone_number: nil) }

  def subscribed_to?(organization)
    subscriptions.where(organization: organization).exists?
  end

  def subscription_to(organization)
    subscriptions.find_by(organization: organization)
  end

  def subscribe_to(organization)
    unsubscribe_from(organization)
    subscriptions.create(organization: organization)
  end

  def unsubscribed_from?(organization)
    !subscribed_to?(organization)
  end

  def unsubscribe_from(organization)
    subscriptions.where(organization: organization).destroy_all
  end

  def name
    "#{first_name} #{last_name}"
  end

  def phone_number
    super || ""
  end
end
