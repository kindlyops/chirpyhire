class Notification < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: :user, only: :create
  has_many :activities, as: :trackable
  belongs_to :template
  belongs_to :user
  delegate :organization, to: :user

  include Messageable
end
