class BillingClerkJob < ApplicationJob
  def perform(invoice)
    BillingClerk.call(invoice)
  end
end
