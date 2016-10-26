class Rule < ApplicationRecord
  TRIGGERS = %w(subscribe screen answer).freeze
  belongs_to :organization
  belongs_to :actionable

  validates :organization, :actionable, presence: true
  validates :trigger, inclusion: { in: TRIGGERS }

  def perform(user)
    typed_actionable.perform(user)
  end

  private

  def typed_actionable
    actionable.becomes(actionable.type.constantize)
  end
end
