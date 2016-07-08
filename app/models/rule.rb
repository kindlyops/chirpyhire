class Rule < ApplicationRecord
  TRIGGERS = %w(subscribe screen answer)
  belongs_to :action, polymorphic: true
  belongs_to :organization

  delegate :perform, to: :action

  validates :organization, :action, presence: true
  validates :action_type, inclusion: { in: %w(Template CandidatePersona) }
  validates :trigger, inclusion: { in: TRIGGERS }
end
