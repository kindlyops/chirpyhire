class BrokerContact < ApplicationRecord
  belongs_to :person
  belongs_to :broker
  delegate :inquiry, to: :person, prefix: true

  def self.unsubscribed
    where(subscribed: false)
  end

  def self.subscribed
    where(subscribed: true)
  end

  def subscribe
    update(subscribed: true)
  end

  def unsubscribe
    update(subscribed: false)
  end
end
