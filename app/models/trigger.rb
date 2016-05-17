class Trigger < ActiveRecord::Base
  belongs_to :organization
  belongs_to :observable, polymorphic: true
  has_many :actions
  enum status: [:enabled, :disabled]
  enum operation: [:subscribe,
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

  def description
    observable.try!(:template_name) || observable_type
  end

  def actions_description
    actions.map(&:description).join(" + ")
  end
end
