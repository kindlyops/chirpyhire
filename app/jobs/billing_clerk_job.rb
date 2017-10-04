class BillingClerkJob < ApplicationJob
  def perform(subscription)
    BillingClerk.call(subscription)
  end
end
