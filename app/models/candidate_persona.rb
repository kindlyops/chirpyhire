class CandidatePersona < ActiveRecord::Base
  belongs_to :organization
  has_many :persona_features
  has_one :rules, as: :action

  alias :features :persona_features

  def perform(user)
    ProfileAdvancer.call(user.candidate)
  end
end
