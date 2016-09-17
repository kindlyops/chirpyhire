# frozen_string_literal: true
class Rule < ApplicationRecord
  TRIGGERS = %w(subscribe screen answer).freeze
  belongs_to :organization
  belongs_to :actionable

  delegate :perform, to: :actionable

  def actionable
    super.becomes(super.type.constantize)
  end

  validates :organization, :actionable, presence: true
  validates :trigger, inclusion: { in: TRIGGERS }
end
