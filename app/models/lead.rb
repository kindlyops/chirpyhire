class Lead < ActiveRecord::Base
  enum relationship: [:candidate, :hired]
  belongs_to :user
  belongs_to :organization
end
