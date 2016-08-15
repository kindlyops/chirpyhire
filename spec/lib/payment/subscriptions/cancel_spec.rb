require 'rails_helper'

RSpec.describe Payment::Subscriptions::Cancel do
  subject { Payment::Subscriptions::Cancel.new(subscription) }

  describe "#call" do
    context "with an existing stripe customer", stripe: { customer: :new, plan: "test", card: :visa, subscription: "test" } do
      let!(:organization) { create(:organization, stripe_customer_id: stripe_customer.id) }
      let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }
      let!(:subscription) { create(:subscription, plan: plan, organization: organization, stripe_id: stripe_subscription.id) }

      it "doesn't raise an error" do
        expect {
          subject.call
        }.not_to raise_error
      end
    end
  end
end
