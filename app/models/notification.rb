class Notification < ActiveRecord::Base
  belongs_to :template
  belongs_to :user
  has_one :message, as: :messageable
  accepts_nested_attributes_for :message
end
