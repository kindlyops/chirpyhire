class Rule < ActiveRecord::Base
  TRIGGERS = %w(subscribe screen answer)
  belongs_to :action, polymorphic: true
  belongs_to :organization

  delegate :perform, to: :action

  validates :organization, :action, presence: true
  validates :action_type, inclusion: { in: %w(Template Profile) }
  validates :trigger, inclusion: { in: TRIGGERS }
end
