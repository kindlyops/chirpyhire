class BillingEvent::Invoice
  def call(event)
    return if event.type == 'invoice.upcoming'
    invoice = Invoice.find_by(stripe_id: event.data.object.id)

    return update(invoice, event) if invoice.present?
    create(event)
  end

  def create(event)
    customer = fetch_customer(event)
    sub = fetch_subscription(event)
    invoice = customer.invoices.new
    invoice.write_attribute(:stripe_id, event.data.object.id)
    invoice.write_attribute(:subscription_id, sub.id) if sub.present?
    update(invoice, event)
  end

  def fetch_customer(event)
    Organization.find_by(stripe_id: event.data.object.customer)
  end

  def fetch_subscription(event)
    ::Subscription.find_by(stripe_id: event.data.object.subscription)
  end

  def update(invoice, event)
    %i[object amount_due application_fee attempt_count attempted billing charge
       closed currency customer date description discount
       ending_balance forgiven lines livemode metadata next_payment_attempt
       number paid period_end period_start receipt_number starting_balance
       statement_descriptor subscription subtotal
       tax tax_percent total webhooks_delivered_at].each do |attribute|
      value = event.data.object.send(attribute)
      invoice.send(:write_attribute, attribute, value)
    end
    invoice.save
  end
end
