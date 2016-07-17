class Rule < ApplicationRecord
  TRIGGERS = %w(subscribe screen answer)
  belongs_to :organization
  belongs_to :actionable

  def perform(user)
    actionable.perform(user)
  end

  def actionable
    super.becomes(super.type.constantize)
  end

  validates :organization, :actionable, presence: true
  validates :trigger, inclusion: { in: TRIGGERS }
end
