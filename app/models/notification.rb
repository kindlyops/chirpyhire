class Notification < ActiveRecord::Base
  belongs_to :notice
  belongs_to :message
end
