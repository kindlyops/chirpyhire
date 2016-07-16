class Notification < ApplicationRecord
  include Messageable
  belongs_to :template
end
