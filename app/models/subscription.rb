class Subscription < ApplicationRecord
  BILLING_UPCOMING_PERIOD = 3.days
  belongs_to :organization
  has_many :invoices, primary_key: :subscription, foreign_key: :stripe_id

  enum internal_status: {
    trialing: 0, active: 1, past_due: 2, canceled: 3, unpaid: 4
  }

  def activate
    update(internal_status: :active)
  end

  def current_engaged_start
    return 30.days.ago if current_period_start.blank?
    DateTime.strptime(current_period_start.to_s, '%s') - BILLING_UPCOMING_PERIOD
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
    @engaged_contact_count ||= begin
      organization.contacts.engaged(current_engaged_start).count
    end
  end
end
