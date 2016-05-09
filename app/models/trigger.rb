class Trigger < ActiveRecord::Base
  belongs_to :organization
  has_many :actions
  enum status: [:enabled, :disabled]
end
