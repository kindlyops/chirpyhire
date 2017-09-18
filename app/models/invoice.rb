class Invoice < ApplicationRecord
  belongs_to :subscription
  delegate :organization, to: :subscription
end
