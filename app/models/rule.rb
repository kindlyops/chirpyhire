class Rule < ActiveRecord::Base
  belongs_to :organization
  belongs_to :trigger, polymorphic: true
  belongs_to :action, polymorphic: true
  delegate :perform, to: :action

  validates :event, inclusion: { in: %w(subscribe invalid_subscribe
                                        answer invalid_answer
                                        refer invalid_refer
                                        invalid_message
                                        unsubscribe invalid_unsubscribe) }

  validates :trigger_type, inclusion: { in: %w(Candidate Question),
      message: "%{value} is not a valid trigger type" }
end
