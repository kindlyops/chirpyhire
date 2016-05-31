class Profile < ActiveRecord::Base
  belongs_to :organization
  has_many :profile_features

  alias :features :profile_features
end
