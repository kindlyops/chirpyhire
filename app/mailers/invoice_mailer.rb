class InvoiceMailer < ApplicationMailer
  layout 'invoice'
  def invoice(invoice)
    @invoice = invoice
    @billing_email = invoice.organization.billing_email
    return if @billing_email.blank? || invoice.organization.silenced_invoices?
    @account = Account.find_by(email: @billing_email)

    track user: @account if @account.present?
    mail(to: @billing_email, subject: @invoice.decorate.subject)
  end
end
