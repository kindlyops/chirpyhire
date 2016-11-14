class Subscription < ApplicationRecord
  INACTIVE_STATUSES = %w(past_due canceled unpaid).freeze
  belongs_to :plan
  belongs_to :organization

  validates :plan, :trial_message_limit, :organization, :state,
            presence: { on: :create }

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
      transitions from: [:active, :trialing], to: :canceled
    end
  end

  def refresh(stripe_subscription:)
    update(stripe_properties(stripe_subscription))
  end

  def over_message_limit?
    finished_trial? || reached_monthly_message_limit?
  end

  # active? represents actually in the active state via aasm, and therefore
  # is not the inverse of inactive?.
  def good_standing?
    !inactive?
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

  def stripe_properties(stripe_subscription)
    formatted_timestamps(stripe_subscription).merge(
      application_fee_percent: stripe_subscription.application_fee_percent,
      cancel_at_period_end:    stripe_subscription.cancel_at_period_end,
      stripe_created_at:       stripe_timestamp(stripe_subscription.created),
      stripe_customer_id:      stripe_subscription.customer,
      quantity:                stripe_subscription.quantity,
      status:                  stripe_subscription.status,
      tax_percent:             stripe_subscription.tax_percent
    )
  end

  def formatted_timestamps(stripe_subscription)
    stripe_timestamps.each_with_object({}) do |timestamp, attributes|
      formatted = stripe_timestamp(stripe_subscription.send(timestamp))
      attributes[timestamp] = formatted
    end
  end

  def stripe_timestamps
    %i(current_period_end
       current_period_start
       ended_at
       start
       trial_end
       trial_start)
  end

  def stripe_timestamp(unix_timestamp)
    return unless unix_timestamp.present?

    Time.at(unix_timestamp).utc.to_datetime
  end
end
