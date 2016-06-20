class IdealProfile < ActiveRecord::Base
  belongs_to :organization
  has_many :ideal_features
  has_one :rules, as: :action

  alias :features :ideal_features

  def perform(user)
    ProfileAdvancer.call(user.candidate)
  end
end
