require 'rails_helper'

RSpec.describe 'Customer Subscription Events' do
  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  %w[customer.subscription.created
     customer.subscription.deleted
     customer.subscription.trial_will_end
     customer.subscription.updated].each do |event|
    describe event do
      let(:body) { File.read("spec/support/fixtures/#{event}.json") }
      let(:event_subscription) { JSON.parse(body)['data']['object'] }
      let!(:organization) { create(:organization, stripe_id: event_subscription['customer']) }
      let(:params) do
        {
          id: event
        }
      end

      before do
        bypass_event_signature body
      end

      context 'subscription does not exist' do
        it 'creates an subscription' do
          expect {
            post '/stripe/events', params: params, env: @env
          }.to change { Subscription.count }.by(1)
        end
      end

      context 'subscription already exists' do
        let!(:subscription) { create(:subscription, stripe_id: event, organization: organization) }

        it 'updates the subscription' do
          expect {
            post '/stripe/events', params: params, env: @env
          }.to change { subscription.reload.updated_at }
        end
      end
    end
  end
end
