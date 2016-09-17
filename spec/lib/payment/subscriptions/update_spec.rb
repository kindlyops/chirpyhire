require 'rails_helper'

RSpec.describe Payment::Subscriptions::Update do
  subject { Payment::Subscriptions::Update.new(subscription, quantity: 2) }

  let!(:stripe_plan) { Stripe::Plan.create(id: "test", amount: 5_000, currency: "usd", interval: "month", name: "test") }

  let(:card) do
    {
      number: "4242424242424242",
      exp_month: "8",
      exp_year: 1.year.from_now.year,
      cvc: "123"
    }
  end

  let(:stripe_customer) { Stripe::Customer.create }
  let(:stripe_token) { Stripe::Token.create(card: card) }
  let!(:stripe_card) { stripe_customer.sources.create(source: stripe_token.id) }
  let!(:stripe_subscription) { stripe_customer.subscriptions.create(plan: stripe_plan.id) }

  after(:each) do
    stripe_plan.delete
    stripe_customer.delete
  end

  describe "#call" do
    context "with an existing stripe customer" do
      let!(:organization) { create(:organization, stripe_customer_id: stripe_customer.id) }
      let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }
      let!(:subscription) { create(:subscription, plan: plan, organization: organization, quantity: 1, stripe_id: stripe_subscription.id) }

      context "with a valid card", vcr: { cassette_name: "Payment::Subscriptions::Update-call" } do
        it "updates the quantity of the stripe subscription" do
          expect {
            subject.call
          }.to change{stripe_subscription.refresh.quantity}.from(1).to(2)
        end

        it "updates the quantity of the subscription" do
          expect {
            subject.call
          }.to change{subscription.reload.quantity}.from(1).to(2)
        end
      end

      context "with an expired stripe card on file", vcr: { cassette_name: "Payment::Subscriptions::Update-call-expired-card" } do
        before(:each) do
          allow_any_instance_of(Stripe::Subscription).to receive(:save).and_raise(Stripe::CardError.new("Expired Card", 402, :expired_card))
        end

        it "raises the Payment::CardError" do
          expect{
            subject.call
          }.to raise_error(Payment::CardError)
        end

        it "does not change the subscription quantity" do
          expect{
            expect{
              subject.call
            }.to raise_error(Payment::CardError)
          }.not_to change{subscription.reload.quantity}
        end
      end
    end
  end
end
