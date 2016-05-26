class Task < ActiveRecord::Base
  belongs_to :message

  delegate :user, to: :message
  delegate :organization, to: :user
end
