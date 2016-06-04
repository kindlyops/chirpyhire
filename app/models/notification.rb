class Notification < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: :user, only: :create

  belongs_to :template
  belongs_to :user
  has_one :message, as: :messageable
  accepts_nested_attributes_for :message
end
