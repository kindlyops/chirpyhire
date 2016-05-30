class Profile < ActiveRecord::Base
  belongs_to :organization
  has_many :features
end
