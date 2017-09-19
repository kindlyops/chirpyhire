class BillingEvent::InvoiceEvents
  def call(event)
    return if event.type == 'invoice.upcoming'
    invoice = Invoice.find_by(stripe_id: event.data.object.id)

    return update(invoice, event.data.object) if invoice.present?
    create(event.data.object)
  end

  def create(stripe_object)
    update(Invoice.new(stripe_id: stripe_object.id), stripe_object)
  end

  def update(invoice, stripe_object)
    %i[object amount_due application_fee attempt_count attempted billing charge
       closed currency customer date description discount
       ending_balance forgiven lines livemode metadata next_payment_attempt
       number paid period_end period_start receipt_number starting_balance
       statement_descriptor subscription subtotal
       tax tax_percent total webhooks_delivered_at].each do |attribute|
      value = stripe_object.send(attribute)
      invoice.send(:write_attribute, attribute, value)
    end
    invoice.save
  end
end
