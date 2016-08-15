require 'rails_helper'

RSpec.describe Payment::Subscriptions::Cancel do
  subject { Payment::Subscriptions::Cancel.new(subscription) }

  describe "#call" do
    context "with an existing stripe customer", stripe: { customer: :new, plan: "test", card: :visa, subscription: "test" } do
      let!(:organization) { create(:organization, stripe_customer_id: stripe_customer.id) }
      let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }
      let!(:subscription) { create(:subscription, plan: plan, organization: organization, stripe_id: stripe_subscription.id) }

      it "cancels the subscription" do
        expect {
          subject.call
        }.to change{subscription.reload.canceled_at}.from(nil)
      end

      it "sets cancel_at_period_end to true" do
        expect {
          subject.call
        }.to change{subscription.reload.cancel_at_period_end}.from(nil).to(true)
      end
    end
  end
end
