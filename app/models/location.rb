class Location < ApplicationRecord
  belongs_to :organization

  validates_length_of :state, is: 2
  validates_length_of :state_code, is: 2
end
