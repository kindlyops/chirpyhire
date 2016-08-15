class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :organization

  validates_presence_of :plan, :quantity, :organization, on: :create

  delegate :stripe_id, to: :plan, prefix: true

  include AASM

  enum state: [:pending, :processing, :active, :canceled, :errored]

  aasm column: :state, enum: true do
    state :pending, initial: true
    state :processing
    state :active
    state :canceled
    state :errored

    event :process, after: :process_subscription do
      transitions from: :pending, to: :processing
    end

    event :activate do
      transitions from: :processing, to: :active
    end

    event :cancel do
      transitions from: :active, to: :canceled
    end

    event :fail do
      transitions from: Subscription.states.keys, to: :errored
    end
  end

  def refresh(stripe_subscription:)
    update(
      stripe_id:               stripe_subscription.id,
      application_fee_percent: stripe_subscription.application_fee_percent,
      cancel_at_period_end:    stripe_subscription.cancel_at_period_end,
      canceled_at:             stripe_timestamp(stripe_subscription.canceled_at),
      stripe_created_at:       stripe_timestamp(stripe_subscription.created),
      current_period_end:      stripe_timestamp(stripe_subscription.current_period_end),
      current_period_start:    stripe_timestamp(stripe_subscription.current_period_start),
      stripe_customer_id:      stripe_subscription.customer,
      ended_at:                stripe_timestamp(stripe_subscription.ended_at),
      quantity:                stripe_subscription.quantity,
      start:                   stripe_timestamp(stripe_subscription.start),
      status:                  stripe_subscription.status,
      tax_percent:             stripe_subscription.tax_percent,
      trial_end:               stripe_timestamp(stripe_subscription.trial_end),
      trial_start:             stripe_timestamp(stripe_subscription.trial_start)
    )
  end

  private

  def process_subscription
    Payment::Subscriptions::Process.call(self)
  end

  def stripe_timestamp(unix_timestamp)
    return unless unix_timestamp.present?

    Time.at(unix_timestamp).utc.to_datetime
  end
end
