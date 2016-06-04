class Chirp < ActiveRecord::Base
  has_one :message, as: :messageable
  belongs_to :user

  delegate :organization, to: :user
  accepts_nested_attributes_for :message
end
