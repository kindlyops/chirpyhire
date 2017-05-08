class BrokerContact < ApplicationRecord
  belongs_to :person
  belongs_to :broker

  def self.unsubscribed
    where(subscribed: false)
  end

  def self.subscribed
    where(subscribed: true)
  end
end
