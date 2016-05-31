class Profile < ActiveRecord::Base
  belongs_to :organization
  has_many :profile_features
  has_one :rules, as: :action

  alias :features :profile_features

  def perform(user)
    ProfileJob.perform_later(user.candidate, self)
  end
end
