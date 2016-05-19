class Rule < ActiveRecord::Base
  belongs_to :organization
  belongs_to :trigger
  belongs_to :action, polymorphic: true
  delegate :perform, to: :action

  validates :trigger, :organization, :action, presence: true
  validates :action_type, inclusion: { in: %w(Notice Question),
      message: "%{value} is not a valid action type" }
end
