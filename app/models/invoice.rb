class Invoice < ApplicationRecord
  belongs_to :subscription

  def refresh(stripe_invoice:)
    update(
      stripe_subscription_id:  stripe_invoice.subscription,
      stripe_charge_id:        stripe_invoice.charge,
      stripe_customer_id:      stripe_invoice.customer,
      amount_due:              stripe_invoice.amount_due,
      application_fee:         stripe_invoice.application_fee,
      attempt_count:           stripe_invoice.attempt_count,
      attempted:               stripe_invoice.attempted,
      closed:                  stripe_invoice.closed,
      currency:                stripe_invoice.currency,
      date:                    stripe_timestamp(stripe_invoice.date),
      description:             stripe_invoice.description,
      discount:                stripe_invoice.discount,
      ending_balance:          stripe_invoice.ending_balance,
      forgiven:                stripe_invoice.forgiven,
      lines:                   stripe_invoice.lines,
      livemode:                stripe_invoice.livemode,
      next_payment_attempt:    stripe_invoice.next_payment_attempt,
      paid:                    stripe_invoice.paid,
      period_end:              stripe_timestamp(stripe_invoice.period_end),
      period_start:            stripe_timestamp(stripe_invoice.period_start),
      receipt_number:          stripe_invoice.receipt_number,
      starting_balance:        stripe_invoice.starting_balance,
      statement_descriptor:    stripe_invoice.statement_descriptor,
      subtotal:                stripe_invoice.subtotal,
      tax:                     stripe_invoice.tax,
      tax_percent:             stripe_invoice.tax_percent,
      total:                   stripe_invoice.total,
      webhooks_delivered_at:   stripe_timestamp(stripe_invoice.webhooks_delivered_at)
    )
  end

  private

  def stripe_timestamp(unix_timestamp)
    return unless unix_timestamp.present?

    Time.at(unix_timestamp).utc.to_datetime
  end
end
