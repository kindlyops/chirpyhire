class AssignmentRule < ApplicationRecord
  belongs_to :organization
  belongs_to :inbox
  belongs_to :phone_number
end
