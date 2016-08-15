module Payment
  class RefreshInvoiceJob < ApplicationJob
    def perform(invoice)
      Payment::Invoices::Refresh.call(invoice)
    end
  end
end
