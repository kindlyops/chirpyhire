class BillingEvent::InvoiceUpcoming < BillingEvent::InvoiceEvents
  def call(event)
    invoice = Invoice.find_by(stripe_id: event.data.object.id)

    invoice = if invoice.present?
                update(invoice, event.data.object)
              else
                create(event.data.object)
              end

    BillingClerkJob.perform_later(invoice)
  end
end
