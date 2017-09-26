class Subscription < ApplicationRecord
  belongs_to :organization
  has_many :invoices, primary_key: :subscription, foreign_key: :stripe_id

  enum internal_status: {
    trialing: 0, active: 1, past_due: 2, canceled: 3, unpaid: 4
  }

  def activate
    update(internal_status: :active)
  end

  def cancel
    update(internal_status: :canceled, internal_canceled_at: DateTime.current)
  end

  def price
    Subscription::Price.call(self)
  end

  def tier
    (engaged_contact_count / 200.0).ceil * 200
  end

  def engaged_contact_count
    @engaged_contact_count ||= organization.contacts.engaged.count
  end
end
