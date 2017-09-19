class InvoiceMailerPreview < ActionMailer::Preview
  def invoice
    InvoiceMailer.invoice(Invoice.first)
  end
end
