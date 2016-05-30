class Profile < ActiveRecord::Base
  belongs_to :organization
  has_many :features

  def advance(user)

  end
end
