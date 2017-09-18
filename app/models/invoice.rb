class Invoice < ApplicationRecord
  belongs_to :subscription, optional: true
  belongs_to :organization
end
