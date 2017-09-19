class Invoice < ApplicationRecord
  belongs_to :subscription, optional: true,
                            foreign_key: :subscription, primary_key: :stripe_id
  belongs_to :organization, foreign_key: :customer, primary_key: :stripe_id
end
