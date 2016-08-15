require 'rails_helper'

RSpec.describe Payment::Subscriptions::Process do
  subject { Payment::Subscriptions::Process.new(subscription) }

  describe "#call" do
    context "without an existing stripe customer", stripe: { token: :visa } do
      let(:organization) { create(:organization, stripe_token: stripe_token.id) }
      let(:subscription) { create(:subscription, organization: organization, state: "trialing") }

      before(:each) do
        organization.update(stripe_customer_id: nil)
      end

      it "creates a stripe customer" do
        expect{
          subject.call
        }.to change{organization.reload.stripe_customer_id}.from(nil)
      end

      it "updates the local subscription" do
        expect{
          subject.call
        }.to change{subscription.reload.stripe_id}.from(nil)
      end

      it "activates the subscription" do
        expect {
          subject.call
        }.to change{subscription.reload.state}.from("trialing").to("active")
      end
    end

    context "with an existing stripe customer", stripe: { customer: :new, plan: "test", card: :visa } do
      let!(:organization) { create(:organization, stripe_customer_id: stripe_customer.id) }
      let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }
      let!(:subscription) { create(:subscription, plan: plan, organization: organization, state: "trialing") }

      it "does not create a new stripe customer" do
        expect{
          subject.call
        }.not_to change{organization.reload.stripe_customer_id}
      end

      it "updates the local subscription" do
        expect{
          subject.call
        }.to change{subscription.reload.stripe_id}.from(nil)
      end

      it "activates the subscription" do
        expect {
          subject.call
        }.to change{subscription.reload.state}.from("trialing").to("active")
      end
    end
  end
end
