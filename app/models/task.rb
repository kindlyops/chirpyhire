class Task < ActiveRecord::Base
  belongs_to :user

  delegate :organization, to: :user
  validates :category, inclusion: { in: %w(reply review) }

  scope :incomplete, -> { where(done: false) }
end
