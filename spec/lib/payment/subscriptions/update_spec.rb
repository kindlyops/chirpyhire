require 'rails_helper'

RSpec.describe Payment::Subscriptions::Update do
  subject { Payment::Subscriptions::Update.new(subscription) }

  describe "#call" do
    context "with an existing stripe customer", stripe: { customer: :new, plan: "test", card: :visa, subscription: "test" } do
      let!(:organization) { create(:organization, stripe_customer_id: stripe_customer.id) }
      let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }
      let!(:subscription) { create(:subscription, plan: plan, organization: organization, quantity: 2, stripe_id: stripe_subscription.id) }

      it "updates the quantity of the subscription" do
        expect {
          subject.call
        }.to change{stripe_subscription.refresh.quantity}.from(1).to(2)
      end
    end
  end
end
