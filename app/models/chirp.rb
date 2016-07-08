class Chirp < ApplicationRecord
  include PublicActivity::Model
  tracked owner: :user, only: :create, outstanding: :inbound?
  has_many :activities, as: :trackable
  belongs_to :user
  delegate :organization, to: :user
  include Messageable

  def inbound?
    direction == "inbound"
  end
end
