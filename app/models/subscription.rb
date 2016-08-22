class Subscription < ApplicationRecord
  INACTIVE_STATUSES = %w(past_due canceled unpaid)
  belongs_to :plan
  belongs_to :organization

  validates_presence_of :plan, :trial_message_limit, :organization, :state, on: :create

  delegate :stripe_id, :name, :price, to: :plan, prefix: true

  include AASM

  enum state: [:trialing, :active, :canceled]

  aasm column: :state, enum: true do
    state :trialing, initial: true
    state :active
    state :canceled

    event :activate do
      transitions from: :trialing, to: :active
    end

    event :cancel do
      transitions from: :active, to: :canceled
    end
  end

  def refresh(stripe_subscription:)
    update(
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

  def in_bad_standing?
    finished_trial? || reached_monthly_message_limit?
  end

  def inactive?
    canceled? || INACTIVE_STATUSES.include?(status)
  end

  def finished_trial?
    trialing? && organization.messages_count >= trial_message_limit
  end

  def trial_remaining_messages_count
    count = trial_message_limit - organization.messages_count
    count.negative? ? 0 : count
  end

  def trial_percentage_remaining
    return 0 unless trial_message_limit.positive?
    ((trial_remaining_messages_count / trial_message_limit.to_f) * 100).floor
  end

  def reached_monthly_message_limit?
    return unless active?
    message_limit = quantity * Plan.messages_per_quantity
    organization.current_month_messages_count >= message_limit
  end

  def price
    return 0 unless quantity.present?
    quantity * Plan::DEFAULT_PRICE_IN_DOLLARS
  end

  private

  def stripe_timestamp(unix_timestamp)
    return unless unix_timestamp.present?

    Time.at(unix_timestamp).utc.to_datetime
  end
end
