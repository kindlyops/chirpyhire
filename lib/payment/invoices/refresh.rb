class Payment::Invoices::Refresh
  def self.call(invoice)
    new(invoice).call
  end

  def initialize(invoice)
    @invoice = invoice
  end

  def call
    invoice.refresh(stripe_invoice: stripe_invoice)
  rescue Stripe::StripeError => e
    invoice.update(error: e.message)
    invoice.fail!
  ensure
    invoice
  end

  private

  def stripe_invoice
    @stripe_invoice ||= Stripe::Invoice.retrieve(invoice.stripe_id)
  end

  attr_reader :invoice, :stripe_invoice

  delegate :organization, to: :invoice
end
