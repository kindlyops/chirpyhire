class Rule < ApplicationRecord
  TRIGGERS = %w(subscribe screen answer)
  belongs_to :organization
  belongs_to :actionable

  def perform(user)
    actionable.becomes(actionable.type.constantize).perform(user)
  end

  validates :organization, :actionable, presence: true
  validates :trigger, inclusion: { in: TRIGGERS }
end
