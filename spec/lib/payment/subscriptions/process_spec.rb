require 'rails_helper'

RSpec.describe Payment::Subscriptions::Process do

  let(:card) do
    {
      number: "4242424242424242",
      exp_month: "8",
      exp_year: 1.year.from_now.year,
      cvc: "123"
    }
  end

  let!(:stripe_token) { Stripe::Token.create(card: card) }
  let!(:stripe_plan) { Stripe::Plan.create(id: "test", amount: 5_000, currency: "usd", interval: "month", name: "test") }

  let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }
  let!(:subscription) { create(:subscription, plan: plan, organization: organization) }

  after(:each) do
    stripe_plan.delete
  end

  let(:email) { "frank.paucek@heathcote.com" }

  subject { Payment::Subscriptions::Process.new(stripe_token.id, subscription, email, {plan_id: plan.id}) }

  describe "#call" do
    context "without an existing stripe customer", vcr: { cassette_name: "Payment::Subscriptions::Process-call-without-stripe-customer" } do
      let(:organization) { create(:organization, name: "Little-Abshire") }

      before(:each) do
        organization.update(stripe_customer_id: nil)
      end

      it "creates a stripe customer" do
        expect{
          subject.call
        }.to change{organization.reload.stripe_customer_id}.from(nil)
      end

      it "activates the subscription" do
        expect {
          subject.call
        }.to change{subscription.reload.state}.from("trialing").to("active")
      end

      it "updates the local subscription" do
        expect{
          subject.call
        }.to change{subscription.reload.stripe_id}.from(nil)
      end

      it "sets the description and email on the stripe customer", vcr: { cassette_name: "Payment::Subscriptions::Process-call-without-stripe-customer-desc-email" } do
        subject.call
        stripe_customer = Stripe::Customer.retrieve(organization.reload.stripe_customer_id)
        expect(stripe_customer.description).to eq(organization.name)
        expect(stripe_customer.email).to eq(email)
      end

      context "with an invalid credit card", vcr: { cassette_name: "Payment::Subscriptions::Process-call-without-stripe-customer-desc-email-invalid-card" } do

        let(:card) do
          {
            number: "4000000000000002",
            exp_month: "8",
            exp_year: 1.year.from_now.year,
            cvc: "123"
          }
        end

        it "raises the Payment::CardError" do
          expect{
            subject.call
          }.to raise_error(Payment::CardError)
        end

        it "does not set the stripe customer id on the organization" do
          expect{
            expect{
              subject.call
            }.to raise_error(Payment::CardError)
          }.not_to change{organization.reload.stripe_customer_id}
        end

        it "does not set the stripe id on the subscription" do
          expect{
            expect{
              subject.call
            }.to raise_error(Payment::CardError)
          }.not_to change{subscription.reload.stripe_id}
        end
      end
    end

    context "with an existing stripe customer", vcr: { cassette_name: "Payment::Subscriptions::Process-call-with-stripe-customer" } do
      let(:stripe_customer) { Stripe::Customer.create }
      let!(:stripe_card) { stripe_customer.sources.create(source: stripe_token.id) }
      let!(:organization) { create(:organization, stripe_customer_id: stripe_customer.id) }

      after(:each) do
        stripe_customer.delete
      end

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
    end
  end
end
