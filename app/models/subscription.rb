class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :organization

  validates_presence_of :plan, :quantity, :organization, on: :create

  include AASM

  enum state: [:pending, :processing, :active, :canceled, :errored]

  aasm column: :state, enum: true do
    state :pending, initial: true
    state :processing
    state :active
    state :canceled
    state :errored

    event :process, after: :start_subscription do
      transitions from: :pending, to: :processing
    end

    event :activate do
      transitions from: :processing, to: :active
    end

    event :cancel do
      transitions from: :active, to: :canceled
    end

    event :fail do
      transitions from: [:pending, :processing], to: :errored
    end

    event :refund do
      transitions from: :finished, to: :refunded
    end
  end

  private

  def start_subscription
    Payment::Subscriptions::Start.call(self)
  end
end
