require 'rails_helper'

RSpec.describe Payment::Subscriptions::Refresh, vcr: { cassette_name: 'Payment::Subscriptions::Refresh-call' } do
  subject { Payment::Subscriptions::Refresh.new(subscription) }

  let!(:stripe_plan) { Stripe::Plan.create(id: 'test', amount: 5_000, currency: 'usd', interval: 'month', name: 'test') }

  let(:card) do
    {
      number: '4242424242424242',
      exp_month: '8',
      exp_year: 1.year.from_now.year,
      cvc: '123'
    }
  end

  let(:stripe_customer) { Stripe::Customer.create }
  let(:stripe_token) { Stripe::Token.create(card: card) }
  let!(:stripe_card) { stripe_customer.sources.create(source: stripe_token.id) }
  let!(:stripe_subscription) { stripe_customer.subscriptions.create(plan: stripe_plan.id) }

  after do
    stripe_plan.delete
    stripe_customer.delete
  end

  describe '#call' do
    context 'with an existing stripe customer' do
      let!(:organization) { create(:organization, stripe_customer_id: stripe_customer.id) }
      let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }
      let!(:subscription) { create(:subscription, plan: plan, organization: organization, quantity: 2, stripe_id: stripe_subscription.id) }

      it 'refreshes the subscription' do
        expect {
          subject.call
        }.to change { subscription.reload.quantity }.from(2).to(1)
      end
    end
  end
end
