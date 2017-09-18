class Subscription < ApplicationRecord
  belongs_to :organization
  has_many :invoices

  enum status: {
    trialing: 0, active: 1, past_due: 2, canceled: 3, unpaid: 4
  }

  def activate
    update(status: :active)
  end

  def cancel
    update(status: :canceled, canceled_at: DateTime.current)
  end

  def price
    Subscription::Price.call(self)
  end
end
