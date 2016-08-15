require 'rails_helper'

RSpec.describe Payment::Subscriptions::Refresh do
  subject { Payment::Subscriptions::Refresh.new(subscription) }

  describe "#call" do
    context "with an existing stripe customer", stripe: { customer: :new, plan: "test", card: :visa, subscription: "test" } do
      let!(:organization) { create(:organization, stripe_customer_id: stripe_customer.id) }
      let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }
      let!(:subscription) { create(:subscription, plan: plan, organization: organization, quantity: 2, stripe_id: stripe_subscription.id) }

      it "refreshes the subscription" do
        expect {
          subject.call
        }.not_to raise_error
      end
    end
  end
end
