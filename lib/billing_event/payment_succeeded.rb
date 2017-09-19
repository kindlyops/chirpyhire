class BillingEvent::PaymentSucceeded
  def call(event)
    invoice = Invoice.find_by(stripe_id: event.data.object.id)
    InvoiceMailer.invoice(invoice).deliver_later
  end
end
