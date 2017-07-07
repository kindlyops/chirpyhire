class Subscription < ApplicationRecord
  belongs_to :organization

  enum status: {
    trialing: 0, active: 1, past_due: 2, canceled: 3, unpaid: 4
  }
end