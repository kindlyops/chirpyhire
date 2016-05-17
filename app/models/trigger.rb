class Trigger < ActiveRecord::Base
  belongs_to :organization
  belongs_to :observable, polymorphic: true
  has_many :actions
  enum status: [:enabled, :disabled]
  enum event: [:subscribe,
                   :invalid_subscribe,
                   :answer,
                   :invalid_answer,
                   :refer,
                   :invalid_refer,
                   :invalid_message,
                   :unsubscribe,
                   :invalid_unsubscribe]

  validates :observable_type, inclusion: { in: %w(Candidate Question),
      message: "%{value} is not a valid observable type" }

  def fire(user)
    actions.each { |action| action.perform(user) }
  end
end
