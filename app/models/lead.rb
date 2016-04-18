class Lead < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :referrals
  has_one :subscription

  delegate :first_name, :phone_number, to: :user
  delegate :name, to: :organization, prefix: true
  delegate :owner_first_name, to: :organization

  def subscribe
    create_subscription
  end

  def unsubscribe
    subscription.destroy
  end

  def subscribed?
    subscription.present?
  end

  def unsubscribed?
    !subscribed?
  end
end
