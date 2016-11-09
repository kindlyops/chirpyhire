class Rule < ApplicationRecord
  TRIGGERS = %w(subscribe screen answer).freeze
  belongs_to :organization
  belongs_to :actionable

  validates :organization, :actionable, presence: true
  validates :trigger, inclusion: { in: TRIGGERS }

  delegate :perform, to: :typed_actionable

  private

  def typed_actionable
    actionable.becomes(actionable.type.constantize)
  end
end
