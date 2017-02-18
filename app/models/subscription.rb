class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :organization

  validates :plan, :trial_message_limit, :organization, :state,
            presence: { on: :create }

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
end
