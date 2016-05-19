class Trigger < ActiveRecord::Base
  belongs_to :organization
  belongs_to :observable, polymorphic: true
  has_many :rules

  validates :event, inclusion: { in: %w(subscribe answer) }

  validates :observable_type, inclusion: { in: %w(Candidate Question),
      message: "%{value} is not a valid observable type" }

end
