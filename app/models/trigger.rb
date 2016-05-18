class Trigger < ActiveRecord::Base
  belongs_to :organization
  belongs_to :observable, polymorphic: true
  has_many :actions

  validates :event, inclusion: { in: %w(subscribe invalid_subscribe
                                        answer invalid_answer
                                        refer invalid_refer
                                        invalid_message
                                        unsubscribe invalid_unsubscribe) }

  validates :observable_type, inclusion: { in: %w(Candidate Question),
      message: "%{value} is not a valid observable type" }

  accepts_nested_attributes_for :actions

  def fire(user)
    actions.each { |action| action.perform(user) }
  end

  def state
    enabled? ? "enabled" : "disabled"
  end
end
