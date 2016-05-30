class Profile < ActiveRecord::Base
  belongs_to :organization
  has_many :profile_features

  def advance(user)

  end
end
