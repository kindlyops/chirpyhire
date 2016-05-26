class Task < ActiveRecord::Base
  belongs_to :message

  delegate :user, to: :message

end
