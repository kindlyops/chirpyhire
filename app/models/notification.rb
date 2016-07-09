class Notification < ApplicationRecord
  include PublicActivity::Model
  include Messageable
  tracked owner: :user, only: :create
  has_many :activities, as: :trackable
  belongs_to :template
end
