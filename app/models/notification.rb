class Notification < ActiveRecord::Base
  belongs_to :template
  belongs_to :message
end
