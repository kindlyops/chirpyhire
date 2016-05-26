class Task < ActiveRecord::Base
  belongs_to :message

  delegate :user, to: :message
  delegate :sender_name, :body, :created_at, to: :message, prefix: true
  delegate :organization, to: :user

  scope :incomplete, -> { where(done: false) }

  def incomplete?
    !done?
  end
end
