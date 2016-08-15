require 'rails_helper'

RSpec.describe Payment::Invoices::Refresh do
  subject { Payment::Invoices::Refresh.new(invoice) }

  describe "#call" do
    context "with an existing stripe customer", stripe: { customer: :new, plan: "test", card: :visa, subscription: "test", invoice: 1_000 } do
      let!(:organization) { create(:organization, stripe_customer_id: stripe_customer.id) }
      let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }
      let!(:subscription) { create(:subscription, plan: plan, organization: organization, stripe_id: stripe_subscription.id) }
      let!(:invoice) { create(:invoice, stripe_subscription_id: stripe_subscription.id, subscription: subscription, stripe_id: stripe_invoice.id) }

      it "refreshes the invoice" do
        expect {
          subject.call
        }.not_to raise_error
      end
    end
  end
end
