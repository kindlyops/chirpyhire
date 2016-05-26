class Task < ActiveRecord::Base
  belongs_to :message

  delegate :user, to: :message
  delegate :organization, to: :user

  scope :incomplete, -> { where(done: false) }

  def incomplete?
    !done?
  end
end
