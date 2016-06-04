class Chirp < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: :user, only: :create, outstanding: :inbound?

  has_one :message, as: :messageable
  belongs_to :user

  delegate :direction, to: :message
  delegate :organization, to: :user
  accepts_nested_attributes_for :message

  def inbound?
    direction == "inbound"
  end
end
