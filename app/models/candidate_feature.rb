class CandidateFeature < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :feature

  enum status: [:unknown, :current]
end
