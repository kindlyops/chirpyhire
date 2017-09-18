class Subscription < ApplicationRecord
  belongs_to :organization

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

  def tier
    (engaged_contact_count / 200.0).ceil * 200
  end

  def engaged_contact_count
    @engaged_contact_count ||= organization.contacts.engaged.count
  end
end
