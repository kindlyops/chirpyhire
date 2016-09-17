# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Payment::Subscriptions::Update, vcr: { cassette_name: 'Payment::Subscriptions::Update-call' } do
  subject { Payment::Subscriptions::Update.new(subscription) }

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

      it 'updates the quantity of the subscription' do
        expect do
          subject.call
        end.to change { stripe_subscription.refresh.quantity }.from(1).to(2)
      end
    end
  end
end
