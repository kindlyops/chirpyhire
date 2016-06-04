class Chirp < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: :user, only: :create

  has_one :message, as: :messageable
  belongs_to :user

  delegate :organization, to: :user
  accepts_nested_attributes_for :message
end
